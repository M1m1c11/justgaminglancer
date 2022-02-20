extends RigidBody

var limit = 10000

# TODO check materials and shaders for FX
# Params.
export var ship_mass = 2000
export var accel_factor = 20 # Propulsion force.
export var accel_ticks_max = 50 # Engine propulsion increments.
# Turning sensitivity LEFT-RIGHT | UP-DOWN | ROLL
export var torque_factor = Vector3(1500,700,700)
export var camera_vert_offset = 0.2
export var camera_horiz_offset = 1 
# Higher damp value - more restricted camera motion in given direction.
export var camera_chase_tilt_horiz_damp_up = 6 # Can't be zero
export var camera_chase_tilt_horiz_damp_down = 1.8 # Can't be zero
export var camera_chase_tilt_vert_damp_left = 2 # Can't be zero
export var camera_chase_tilt_vert_damp_right = 2 # Can't be zero
# Higher values - more responsive camera.
export var camera_tilt_velocity_factor = 1
export var camera_push_velocity_factor = 0.01





# Vars.
var default_linear_damp = 0

# Objects.
var torque = Vector3(0,0,0)

# Nodes.
onready var p = get_tree().get_root().get_node("Container/Paths")
var engines = Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# ============================ Initialize nodes ===========================

	engines = get_node("Engines")

	# ============================= Connect signals ===========================
	p.signals.connect("sig_accelerate", self, "is_accelerating")
	p.signals.connect("sig_engine_kill", self, "is_engine_kill")
	# =========================================================================
	
	# Get default values.
	default_linear_damp = p.engine_opts.ship_linear_damp
	
	# Initialize the vessel params.
	init_ship()

func _physics_process(_delta):
	
	# Testing origin rebase. Start this only at some point.
	# 10k seems like the optimal.
	
	
	if self.translation.x > limit:
		self.translation.x = 0
		p.local_space.translation.x = p.local_space.translation.x-limit
	elif self.translation.x < -limit:
		self.translation.x = 0
		p.local_space.translation.x = p.local_space.translation.x+limit
		
	if self.translation.y > limit:
		self.translation.y = 0
		p.local_space.translation.y = p.local_space.translation.y-limit
	elif self.translation.y < -limit:
		self.translation.y = 0
		p.local_space.translation.y = p.local_space.translation.y+limit

	if self.translation.z > limit:
		self.translation.z = 0
		p.local_space.translation.z = p.local_space.translation.z-limit
	elif self.translation.z < -limit:
		self.translation.z = 0
		p.local_space.translation.z = p.local_space.translation.z+limit


func _integrate_forces(state):
	
	#print("L: ", state.total_linear_damp, "   A: ", state.total_angular_damp)
	# TODO: arrange for proper signs for accel and torque.
	var vel = state.linear_velocity.length()
	p.ship_state.ship_linear_velocity = vel
	# Since everything is scaled down 10 times, then:
	p.ship_state.apparent_velocity = vel*10
	
	# Limit by origin rebase speed (600000 u/s).
	if not p.ship_state.engine_kill and vel < limit* p.engine_opts.physics_fps*0.9:
		state.add_central_force(-global_transform.basis.z* p.ship_state.acceleration* p.ship_state.acceleration)
	
	# Limiting by engine ticks. It is a hard limits.
	# TODO: move capped velocity to constants.
	if vel > 1000000:
		p.signals.emit_signal("sig_accelerate", false)

	
	if not p.ship_state.turret_mode and (p.input.LMB_held or p.ship_state.mouse_flight):

		var tx = -transform.basis.y*self.torque_factor.x* p.input.mouse_vector.x
		var ty = -transform.basis.x*self.torque_factor.y* p.input.mouse_vector.y
		
		state.add_torque(tx+ty)
		

# ================================== Other ====================================
# TODO: Split it off to self's specific properties later on.
func init_ship():
	# Enable continuous collision detection
	# TODO: enable ccd based on velocity
	self.continuous_cd = true
	self.custom_integrator = true
	self.can_sleep = false
	self.mass = self.ship_mass
	self.linear_damp = p.engine_opts.ship_linear_damp
	self.angular_damp = p.engine_opts.ship_angular_damp
	adjust_exhaust()

func adjust_exhaust():
	for i in engines.get_children():
		
		# Adjust shape size.
		i.get_node("Engine_exhaust_shapes").scale.z = \
				pow(p.ship_state.accel_ticks, 1.5)*0.1

		var albedo =  pow(p.ship_state.accel_ticks, 1.5)*0.1
		# Get and modify sprite intensity.
		var shapes = i.get_node("Engine_exhaust_shapes")
		for shape in shapes.get_children():
			var m = shape.get_surface_material(0)
			
			m["shader_param/albedo"].r = clamp(albedo*0.4, 0.0, 0.6)
			m["shader_param/albedo"].g = clamp(albedo*0.1, 0.0, 0.2)
			m["shader_param/albedo"].b = clamp(albedo*0.05, 0.0, 0.8)
		
		# Adjust light intensity
		if p.ship_state.accel_ticks > 0:
			i.get_node("Engine_exhaust_light").light_energy = \
					p.ship_state.accel_ticks * 0.1
		else:
			i.get_node("Engine_exhaust_light").light_energy = 0.1

# ============================ Signal processing ==============================
func is_accelerating(flag):

	# TODO: make engine state readouts.
	if flag and not p.ship_state.engine_kill and (p.ship_state.accel_ticks < self.accel_ticks_max):
		p.ship_state.accel_ticks += 1
		p.ship_state.acceleration += p.ship_state.accel_ticks*self.accel_factor
	elif not flag and not p.ship_state.engine_kill and (p.ship_state.accel_ticks > 0):
		p.ship_state.acceleration -= p.ship_state.accel_ticks*self.accel_factor
		p.ship_state.accel_ticks -= 1
	adjust_exhaust()
	
# TODO: make a button-hold temporary kill.
func is_engine_kill(flag):
	if flag:
		p.ship_state.acceleration = 0
		p.ship_state.accel_ticks = 0
		# Enable inertia-less flight.
		p.ship_state.engine_kill = false
		# p.ship_state.accel_ticks_prev = p.ship_state.accel_ticks
		# p.ship_state.accel_ticks = 0
		# self.linear_damp = p.engine_opts.ship_linear_damp_ekill
	else:
		p.ship_state.engine_kill = false
		# Disable inertia-less flight.
		# p.ship_state.engine_kill = false
		# p.ship_state.accel_ticks = p.ship_state.accel_ticks_prev
		# self.linear_damp = p.engine_opts.ship_linear_damp
	adjust_exhaust()
