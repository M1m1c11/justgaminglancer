extends Spatial

#TODO: make this scene instance to any object that is focused on in game.

# Values.
var camera_min_zoom = 0
var camera_max_zoom = 0
var current_zoom = 0
var camera_x = 0
var camera_y = 0
var zoom_ticks = 0
# Objects.
var mouse_vector = Vector2(0,0)
# Flags.
var LMB_held = false
var turret_mode = false
# Nodes.
var cam_opts = Node
var input = Node
var ui = Node
var signals = Node

func _ready():
	# ============================ Initialize nodes ===========================
	input = get_node("/root/Main/Input")
	cam_opts = get_node("/root/Main/Options/Camera")
	ui = get_node("/root/Main/UI")
	signals = get_node("/root/Main/Input/Signals")
	# ============================ Connect signals ============================
	signals.connect("sig_turret_mode", self, "is_turret_mode_on")
	signals.connect("sig_LMB_held", self, "is_LMB_held")
	# =========================================================================
	
	# TODO: make reference to model universal.
	# Puts camera at proper distance from the model at start.
	camera_min_zoom = round(get_node("../Rogue_fighter/Ship_model") \
		.get_aabb().get_longest_axis_size())
	camera_max_zoom = camera_min_zoom*cam_opts.camera_zoom_out_times
	current_zoom = camera_min_zoom
	fix_camera()
	
func _process(delta):
	# Track the change in camera mode and update mouse vector when LMB is held.
	if turret_mode and LMB_held:
		mouse_vector = input.mouse_vector
		orbit_camera(mouse_vector)
	elif turret_mode and not LMB_held:
		# Stop inertia at small value of the vector.
		if abs(mouse_vector.x) > 0.01:
			mouse_vector /= cam_opts.camera_inertia_factor
			yield(get_tree().create_timer(delta), "timeout")
			orbit_camera(mouse_vector)
			
			
# ================================== Other ====================================
func orbit_camera(mv):
	var roll_horiz = -mv.y*cam_opts.camera_sensitivity
	var roll_vert = -mv.x*cam_opts.camera_sensitivity
	camera_x = self.rotation_degrees.x
	camera_y = self.rotation_degrees.y
	# X local, Y global.
	self.rotate_y(deg2rad(roll_vert))
	if camera_x + roll_horiz >= cam_opts.camera_vert_limit_deg:
		self.rotation_degrees.x = cam_opts.camera_vert_limit_deg
	elif camera_x + roll_horiz <= -cam_opts.camera_vert_limit_deg:
		self.rotation_degrees.x = -cam_opts.camera_vert_limit_deg
	else:
		self.rotate_object_local(Vector3(1,0,0), deg2rad(roll_horiz))

# Initial position for turret camera
func turret_camera():
	$Camera.translation.y = 0
	zoom_ticks = 0
	current_zoom = camera_min_zoom

# Initial position for chase camera
func fix_camera():
	self.rotation_degrees.x = 0
	self.rotation_degrees.y = 0
	self.rotation_degrees.z = 0
	$Camera.translation.z = camera_min_zoom+cam_opts.camera_chase_offset
	$Camera.translation.y = cam_opts.camera_vert_offset
	zoom_ticks = 0
	current_zoom = camera_min_zoom
	
func zoom_camera(mouse_event):
	if mouse_event.is_pressed():
		if mouse_event.button_index == BUTTON_WHEEL_UP and \
		current_zoom <= camera_max_zoom:
			zoom_ticks += 1
			current_zoom += cam_opts.camera_zoom_step*zoom_ticks
			$Camera.translation.z = current_zoom
		elif mouse_event.button_index == BUTTON_WHEEL_DOWN and \
		current_zoom >= camera_min_zoom and zoom_ticks > 0:
			current_zoom -= cam_opts.camera_zoom_step*zoom_ticks
			zoom_ticks -= 1
			$Camera.translation.z = current_zoom

# ============================ Signal processing ==============================
func is_turret_mode_on(flag):
	if flag:
		turret_mode = true
		self.turret_camera()
	else:
		turret_mode = false
		self.fix_camera()

func is_LMB_held(flag):
	LMB_held = flag

