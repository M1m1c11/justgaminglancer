extends RigidBody

# TODO check materials and shaders for FX
# Params.
var ship_mass = 1e6
var accel_factor = 1e3 # Propulsion force.
var accel_ticks_max = pow(2,28) # Engine propulsion increments. Pow 2.
# Turning sensitivity LEFT-RIGHT | UP-DOWN | ROLL
var torque_factor = Vector3(15e8,7e8,7e8)
var camera_vert_offset = 1
var camera_horiz_offset = 6
# Higher damp value - more restricted camera motion in given direction.
var camera_chase_tilt_horiz_damp_up = 6 # Can't be zero
var camera_chase_tilt_horiz_damp_down = 1.8 # Can't be zero
var camera_chase_tilt_vert_damp_left = 2 # Can't be zero
var camera_chase_tilt_vert_damp_right = 2 # Can't be zero
# Higher values - more responsive camera.
var camera_tilt_velocity_factor = 1

var camera_push_velocity_factor = 2.5
var camera_push_max_factor = 1000.0
const camera_push_visibility_velocity = 1e8

var spawned = false

# Vars.
var default_linear_damp = 0

# Objects.
var torque = Vector3(0,0,0)

# Nodes.
onready var p = get_tree().get_root().get_node("Main/Paths")
onready var engines = get_node("Engines")


# Called when the node enters the scene tree for the first time.
func _ready():
	# ============================= Connect signals ===========================
	p.signals.connect("sig_accelerate", self, "is_accelerating")
	p.signals.connect("sig_engine_kill", self, "is_engine_kill")
	# =========================================================================
	
	# Get default values.
	default_linear_damp = p.common_engine.ship_linear_damp
	
	# Initialize the vessel params.
	init_ship()
	



func _integrate_forces(state):	
	
	#print("L: ", state.total_linear_damp, "   A: ", state.total_angular_damp)
	# TODO: arrange for proper signs for accel and torque.
	var vel = state.linear_velocity.length()
	p.ship_state.ship_linear_velocity = vel
	p.ship_state.apparent_velocity = vel
	
	# Modify origin rebase limit.
	if vel > p.common_engine.rebase_limit_margin*p.common_engine.rebase_lag:
		p.global_space.rebase_limit = round(vel*p.common_engine.rebase_lag)
	
	state.add_central_force(-global_transform.basis.z* p.ship_state.acceleration* p.ship_state.acceleration)
	
	# Limiting by engine ticks. It is a hard rebase_limits.
	# TODO: move capped velocity to constants.
	#if vel > 2000000:
	#	p.signals.emit_signal("sig_accelerate", false)

	
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
	self.linear_damp = p.common_engine.ship_linear_damp
	self.angular_damp = p.common_engine.ship_angular_damp
	adjust_exhaust()


func adjust_exhaust():
	for i in engines.get_children():
		
		# Adjust shape size.
		i.get_node("Engine_exhaust_shapes").scale.z = \
				pow(p.ship_state.accel_ticks, 1.2)*0.05

		var albedo =  log(p.ship_state.accel_ticks)

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
					p.ship_state.accel_ticks * 0.05
		else:
			i.get_node("Engine_exhaust_light").light_energy = 0.1



# SIGNAL PROCESSING
func is_accelerating(flag):
	if flag and (p.ship_state.accel_ticks < self.accel_ticks_max):
		if p.ship_state.accel_ticks == 0:
			p.ship_state.accel_ticks = 1
		p.ship_state.accel_ticks *= 2
		p.ship_state.acceleration += p.ship_state.accel_ticks*self.accel_factor
	elif not flag and (p.ship_state.accel_ticks > 0):
		p.ship_state.acceleration -= p.ship_state.accel_ticks*self.accel_factor
		p.ship_state.accel_ticks /= 2
		if p.ship_state.accel_ticks == 1:
			p.ship_state.accel_ticks = 0
	adjust_exhaust()
	
func is_engine_kill():
	p.ship_state.acceleration = 0
	p.ship_state.accel_ticks = 0
	adjust_exhaust()
