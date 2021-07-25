extends RigidBody

# Vars.
var accel_ticks = 0
var accel_ticks_prev = 0
var accel_ticks_max = 0
var default_linear_damp = 0
# Objects.
var acceleration = 0
var accel_factor = 0
var torque = Vector3(0,0,0)
var torque_factor = Vector3(0,0,0)
# Nodes.
var engines = Node
var engine_opts = Node
var input = Node
var local_space = Node
var ui = Node
var signals = Node
var player_ship_state = Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# ============================ Initialize nodes ===========================
	engines = get_node("Engines")
	engine_opts = get_node("/root/Main/Options/Engine")
	input = get_node("/root/Main/Input")
	local_space = get_node("/root/Main/Local_space")
	ui = get_node("/root/Main/UI")
	signals = get_node("/root/Main/Input/Signals")
	player_ship_state = get_node("/root/Main/State/Player_ship")
	# ============================= Connect signals ===========================
	signals.connect("sig_accelerate", self, "is_accelerating")
	signals.connect("sig_engine_kill", self, "is_engine_kill")
	# =========================================================================
	
	# Get default values.
	default_linear_damp = engine_opts.ship_linear_damp
	
	# Initialize the vessel params.
	init_ship()
	
func _integrate_forces(state):
	#print("L: ", state.total_linear_damp, "   A: ", state.total_angular_damp)
	# TODO: arrange for proper signs for accel and torque.

	if not player_ship_state.engine_kill:
		state.add_central_force(-global_transform.basis.z*acceleration)
	
	if not player_ship_state.turret_mode and (input.LMB_held or player_ship_state.mouse_flight):
		var torque = Vector3( \
			-input.mouse_vector.y, \
			-input.mouse_vector.x, \
			0) \
				*torque_factor 
		var tx = -transform.basis.y*torque_factor.x*input.mouse_vector.x
		var ty = -transform.basis.x*torque_factor.y*input.mouse_vector.y
		
		state.add_torque(tx+ty)
	
	#print(state.linear_velocity, " ticks: ", accel_ticks)

# ================================== Other ====================================
func init_ship():
	self.custom_integrator = true
	self.can_sleep = false
	
	self.mass = 1000
	self.linear_damp = engine_opts.ship_linear_damp
	self.angular_damp = engine_opts.ship_angular_damp
	
	accel_factor = 10000 # Propulsion force.
	accel_ticks_max = 10 # Engine propulsion increments.
	torque_factor = Vector3(50000,50000,50000)
	
	adjust_exhaust()

func adjust_exhaust():
	for i in engines.get_children():
		i.scale.z = accel_ticks
		if accel_ticks > 0:
			i.get_node("Engine_exhaust_light").light_energy = accel_ticks
		else:
			i.get_node("Engine_exhaust_light").light_energy = 0.1
			
			
# ============================ Signal processing ==============================
func is_accelerating(flag):
	# TODO: make engine state readouts.
	if flag and not player_ship_state.engine_kill and (accel_ticks < accel_ticks_max):
		accel_ticks += 1
		acceleration += accel_ticks*accel_factor
	elif not flag and not player_ship_state.engine_kill and (accel_ticks > 0):
		acceleration -= accel_ticks*accel_factor
		accel_ticks -= 1
	adjust_exhaust()

# TODO: make a button-hold temporary kill.
func is_engine_kill(flag):
	if flag:
		# Enable inertia-less flight.
		player_ship_state.engine_kill = true
		accel_ticks_prev = accel_ticks
		accel_ticks = 0
		self.linear_damp = -1
	else:
		# Disable inertia-less flight.
		player_ship_state.engine_kill = false
		accel_ticks = accel_ticks_prev
		self.linear_damp = engine_opts.ship_linear_damp
	adjust_exhaust()
