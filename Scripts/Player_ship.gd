extends RigidBody

# TODO check materials and shaders for FX
# Params.
export var ship_mass = 2000
export var accel_factor = 10000 # Propulsion force.
export var accel_ticks_max = 10 # Engine propulsion increments.
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
var accel_ticks = 0
var accel_ticks_prev = 0
var default_linear_damp = 0
var acceleration = 0
var ship_linear_velocity = 0
# Objects.
var torque = Vector3(0,0,0)
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
	engine_opts = get_node("/root/Cont/View/Main/Options/Engine")
	input = get_node("/root/Cont/View/Main/Input")
	local_space = get_node("/root/Cont/View/Main/Local_space")
	ui = get_node("/root/Cont/UI")
	signals = get_node("/root/Cont/View/Main/Input/Signals")
	player_ship_state = get_node("/root/Cont/View/Main/State/Player_ship")
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
	var limit = 10000
	
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
	ship_linear_velocity = state.linear_velocity.length()
	# Since everything is scaled down 10 times, then:
	player_ship_state.apparent_velocity = ship_linear_velocity*10
	
	if not player_ship_state.engine_kill:
		state.add_central_force(-global_transform.basis.z*acceleration)
	
	if not player_ship_state.turret_mode and (input.LMB_held or player_ship_state.mouse_flight):

		var tx = -transform.basis.y*torque_factor.x*input.mouse_vector.x
		var ty = -transform.basis.x*torque_factor.y*input.mouse_vector.y
		
		state.add_torque(tx+ty)
		

# ================================== Other ====================================
# TODO: Split it off to ship's specific properties later on.
func init_ship():
	# Enable continuous collision detection
	self.continuous_cd = true
	self.custom_integrator = true
	self.can_sleep = false
	self.mass = ship_mass
	self.linear_damp = engine_opts.ship_linear_damp
	self.angular_damp = engine_opts.ship_angular_damp
	adjust_exhaust()

func adjust_exhaust():
	for i in engines.get_children():
		i.scale.z = pow(accel_ticks, 1.5)*0.01
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
		self.linear_damp = engine_opts.ship_linear_damp_ekill
	else:
		# Disable inertia-less flight.
		player_ship_state.engine_kill = false
		accel_ticks = accel_ticks_prev
		self.linear_damp = engine_opts.ship_linear_damp
	adjust_exhaust()
