extends RigidBody

var limit = 5000
# TODO check materials and shaders for FX
# Params.
export var ship_mass = 2000
export var accel_factor = 20 # Propulsion force.
export var accel_ticks_max = 500 # Engine propulsion increments.
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
export var camera_push_velocity_factor = 2





# Vars.
var default_linear_damp = 0

# Objects.
var torque = Vector3(0,0,0)
# Nodes.
var engines = Node
var engine_opts = Node
var input = Node
var local_space = Node
var ui = Node
var signals = Node
var ship_state = Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# ============================ Initialize nodes ===========================
	engines = get_node("Engines")
	engine_opts = get_node("/root/Cont/View/Main/Options/Engine")
	input = get_node("/root/Cont/View/Main/Input")
	local_space = get_node("/root/Cont/View/Main/Local_space")
	ui = get_node("/root/Cont/UI")
	signals = get_node("/root/Cont/View/Main/Input/Signals")
	ship_state = get_node("Ship_state")

	# ============================= Connect signals ===========================
	signals.connect("sig_accelerate", self, "is_accelerating")
	signals.connect("sig_engine_kill", self, "is_engine_kill")
	# =========================================================================
	
	# Get default values.
	default_linear_damp = engine_opts.ship_linear_damp
	
	# Initialize the vessel params.
	init_ship()


func _physics_process(_delta):
	
	# Testing origin rebase. Start this only at some point.
	# 10k seems like the optimal.
	
	
	if self.translation.x > limit:
		self.translation.x = 0
		local_space.translation.x = local_space.translation.x-limit
	elif self.translation.x < -limit:
		self.translation.x = 0
		local_space.translation.x = local_space.translation.x+limit
		
	if self.translation.y > limit:
		self.translation.y = 0
		local_space.translation.y = local_space.translation.y-limit
	elif self.translation.y < -limit:
		self.translation.y = 0
		local_space.translation.y = local_space.translation.y+limit

	if self.translation.z > limit:
		self.translation.z = 0
		local_space.translation.z = local_space.translation.z-limit
	elif self.translation.z < -limit:
		self.translation.z = 0
		local_space.translation.z = local_space.translation.z+limit



func _integrate_forces(state):
	
	#print("L: ", state.total_linear_damp, "   A: ", state.total_angular_damp)
	# TODO: arrange for proper signs for accel and torque.
	var vel = state.linear_velocity.length()
	ship_state.ship_linear_velocity = vel
	# Since everything is scaled down 10 times, then:
	ship_state.apparent_velocity = vel*10
	
	# Limit by origin rebase speed (600000 u/s).
	if not ship_state.engine_kill and vel < limit*engine_opts.physics_fps:
		state.add_central_force(-global_transform.basis.z*ship_state.acceleration*ship_state.acceleration)
	
	# Limiting by engine ticks. It is a hard limits.
	if vel > limit*engine_opts.physics_fps:
		signals.emit_signal("sig_accelerate", false)
	
	if not ship_state.turret_mode and (input.LMB_held or ship_state.mouse_flight):

		var tx = -transform.basis.y*self.torque_factor.x*input.mouse_vector.x
		var ty = -transform.basis.x*self.torque_factor.y*input.mouse_vector.y
		
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
	self.linear_damp = engine_opts.ship_linear_damp
	self.angular_damp = engine_opts.ship_angular_damp
	adjust_exhaust()

func adjust_exhaust():
	for i in engines.get_children():
		i.scale.z = pow(ship_state.accel_ticks, 1.5)*0.01
		if ship_state.accel_ticks > 0:
			i.get_node("Engine_exhaust_light").light_energy = ship_state.accel_ticks
		else:
			i.get_node("Engine_exhaust_light").light_energy = 0.1

# ============================ Signal processing ==============================
func is_accelerating(flag):
	# TODO: make engine state readouts.
	if flag and not ship_state.engine_kill and (ship_state.accel_ticks < self.accel_ticks_max):
		ship_state.accel_ticks += 1
		ship_state.acceleration += ship_state.accel_ticks*self.accel_factor
	elif not flag and not ship_state.engine_kill and (ship_state.accel_ticks > 0):
		ship_state.acceleration -= ship_state.accel_ticks*self.accel_factor
		ship_state.accel_ticks -= 1
	adjust_exhaust()
	
# TODO: make a button-hold temporary kill.
func is_engine_kill(flag):
	if flag:
		# Enable inertia-less flight.
		ship_state.engine_kill = true
		ship_state.accel_ticks_prev = ship_state.accel_ticks
		ship_state.accel_ticks = 0
		self.linear_damp = engine_opts.ship_linear_damp_ekill
	else:
		# Disable inertia-less flight.
		ship_state.engine_kill = false
		ship_state.accel_ticks = ship_state.accel_ticks_prev
		self.linear_damp = engine_opts.ship_linear_damp
	adjust_exhaust()
