extends RigidBody

# TODO check materials and shaders for FX
# Params.
var ship_mass = 1e6
var accel_factor = 1e3 # Propulsion force.
var accel_ticks_max = pow(2,23) # Engine propulsion increments. Pow 2.
const ship_linear_damp = 1
const ship_angular_damp = 5
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

var engine_step_delay = 0.2

var autopilot_angle_deviation = 0.8

# Lesser is more precise, aim at ration 1:2 for decel being larger
# Higher numbers mean more agressive AP velocity handling.
var autopilot_accel_factor = 0.3
var autopilot_deccel_factor = 0.6

# Orbiting factor allows to approach not at a straight line, but slightly orbiting.
var autopilot_orbiting_factor = 0.1 # Keep it small. Less than 1.0 - deviation

# Vars.
var default_linear_damp = 0
var tx = 0
var ty = 0
var tz = 0
var engine_delay = false

var autopilot_target = Position3D
var target_origin = Vector3(0,0,0)
var autopilot_range = 0

var dist_val = 0
var steering_vector = Vector3(0,0,0)


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
	p.signals.connect("sig_autopilot_start", self, "is_autopilot_start")
	p.signals.connect("sig_autopilot_disable", self, "is_autopilot_disable")
	# =========================================================================
	
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
	if vel > p.common_constants.C*0.01 and self.continuous_cd:
		self.continuous_cd = false
		print("disable ship CCD due to high velocity")
	elif vel < p.common_constants.C*0.01 and not self.continuous_cd:
		self.continuous_cd = true
		print("enable ship CCD")


	# AUTOPILOT
	
	# Coordinates must be within physics process because they are updating.
	if p.ship_state.autopilot_target_locked:
		target_origin = autopilot_target.global_transform.origin
		autopilot_range = autopilot_target.autopilot_range
	
	#print(autopilot_range)

	
	# Acceleration control.
	if p.ship_state.autopilot:

		var ship_origin = self.global_transform.origin
		dist_val = round(ship_origin.distance_to(target_origin))
		var ship_forward = -self.global_transform.basis.z
		var dir_vector = ship_origin.direction_to(target_origin)
		var dot_product = ship_forward.dot(dir_vector)

		steering_vector = ship_forward.cross(dir_vector)
		
		# TODO: improve acceleration rate based on distance.
		if (vel < dist_val*autopilot_accel_factor) and (dot_product > autopilot_angle_deviation)\
			and (dist_val > autopilot_range):
			is_accelerating(true)
		elif (vel > dist_val*autopilot_deccel_factor) or (dot_product < autopilot_angle_deviation)\
			or (dist_val < autopilot_range): 
			is_accelerating(false)
	
	if p.ship_state.autopilot and dist_val < autopilot_range:
		p.signals.emit_signal("sig_autopilot_disable")
	
	# Steering.
	# Get deltas (multiply and clamp):
	var autopilot_torque_factor = 10

	var autopilot_factor_x = clamp(autopilot_torque_factor*steering_vector.x+autopilot_orbiting_factor, -1.0, 1.0)
	var autopilot_factor_y = clamp(autopilot_torque_factor*steering_vector.y+autopilot_orbiting_factor, -1.0, 1.0)
	var autopilot_factor_z = clamp(autopilot_torque_factor*steering_vector.z+autopilot_orbiting_factor, -1.0, 1.0)

	
	# Due to difference in handling LMB and stick actuation, check those separately for
	# different game modes.
	var control_held = false
	if not p.main.touchscreen_mode and p.input.LMB_held:
		control_held = true
	elif p.main.touchscreen_mode and p.ui.stick_held:
		control_held = true
	else: 
		control_held = false
	
	
	if not (control_held or p.ship_state.mouse_flight) and p.ship_state.autopilot:

		# Fix directions being flipped

		tx = self.torque_factor.x* autopilot_factor_x
		ty = self.torque_factor.y* autopilot_factor_y
		tz = self.torque_factor.z* autopilot_factor_z

		state.add_torque(Vector3(tx, ty, tz))
	
	
	
	
	
	# AUTOPILOT




	
	if not p.ship_state.turret_mode and (p.input.LMB_held or p.ship_state.mouse_flight):

		var tx = -transform.basis.y*self.torque_factor.x* p.input.mouse_vector.x
		var ty = -transform.basis.x*self.torque_factor.y* p.input.mouse_vector.y
		
		state.add_torque(tx+ty)
	
	#print(state.get_total_angular_damp())


	# DAMPING
	var damp_coeff = 1e-4
	var damp_linear = 1.0 - state.step * ship_linear_damp

	if (damp_linear < 0):
		damp_linear = 0


	var damp_angular = 1.0 - state.step * ship_angular_damp 

	if (damp_angular < 0):
		damp_angular = 0
	
	state.linear_velocity *= damp_linear
	state.angular_velocity *= damp_angular



# ================================== Other ====================================
# TODO: Split it off to self's specific properties later on.
func init_ship():
	# Enable continuous collision detection
	# TODO: enable ccd based on velocity
	self.continuous_cd = true
	self.custom_integrator = true
	self.can_sleep = false
	self.mass = self.ship_mass
	adjust_exhaust()
	engine_cooldown()
	
func engine_cooldown():
	get_tree().create_timer(engine_step_delay).connect("timeout", self, "set_timing", [false])

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
func is_accelerating_old(flag):
	if flag and (p.ship_state.accel_ticks < accel_ticks_max) and not engine_delay:
		if p.ship_state.accel_ticks == 0:
			p.ship_state.accel_ticks = 1
		p.ship_state.accel_ticks *= 2
		p.ship_state.acceleration += p.ship_state.accel_ticks*accel_factor
		engine_delay = true
	elif not flag and (p.ship_state.accel_ticks > 0) and not engine_delay:
		p.ship_state.acceleration -= p.ship_state.accel_ticks*accel_factor
		p.ship_state.accel_ticks /= 2
		if p.ship_state.accel_ticks == 1:
			p.ship_state.accel_ticks = 0
		engine_delay = true
	adjust_exhaust()
	
func is_accelerating(flag):
	if flag and (p.ship_state.accel_ticks < accel_ticks_max) and not engine_delay:
		if p.ship_state.accel_ticks == 0:
			p.ship_state.accel_ticks = 1
		p.ship_state.accel_ticks *= 2
		p.ship_state.acceleration += p.ship_state.accel_ticks*accel_factor
		engine_delay = true
	elif not flag and (p.ship_state.accel_ticks > 0) and not engine_delay:
		p.ship_state.acceleration -= p.ship_state.accel_ticks*accel_factor
		p.ship_state.accel_ticks /= 2
		if p.ship_state.accel_ticks == 1:
			p.ship_state.accel_ticks = 0
		engine_delay = true
	adjust_exhaust()

func set_timing(value: bool):
	#print("time")
	engine_delay = value
	# Reset timer
	engine_cooldown()


func is_engine_kill():
	p.ship_state.acceleration = 0
	p.ship_state.accel_ticks = 0
	adjust_exhaust()


func is_autopilot_start():
	if p.ship_state.autopilot_target_locked:
		autopilot_target = p.ship_state.autopilot_target
		p.ship_state.autopilot = true
	
func is_autopilot_disable():
	is_engine_kill()
	p.ship_state.autopilot = false
