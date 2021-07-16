extends Spatial

#TODO: make this scene instance to any object that is focused on in game.

var camera_sensitivity = 0
var camera_vert_limit_deg = 0
var camera_zoom_out_times = 0
var camera_zoom_step = 0
var camera_vert_offset = 0
var camera_chase_offset = 0
var camera_min_zoom = 0
var camera_max_zoom = 0
var current_zoom = 0
var zoom_ticks = 0
var camera_x = 0
var camera_y = 0

func _ready():
	# ============================== Options values ===========================
	var options = get_node("/root/Main/Game_options/Camera")
	camera_sensitivity = options.camera_sensitivity
	camera_vert_limit_deg = options.camera_vert_limit_deg
	camera_zoom_out_times = options.camera_zoom_out_times
	camera_zoom_step = options.camera_zoom_step
	camera_vert_offset = options.camera_vert_offset
	camera_chase_offset = options.camera_chase_offset
	# =========================================================================
	
	# TODO: make reference to model universal.
	# Puts camera at proper distance from the model at start.
	camera_min_zoom = round(get_node("../Rogue_fighter/Ship_model") \
		.get_aabb().get_longest_axis_size())
	camera_max_zoom = camera_min_zoom*camera_zoom_out_times
	current_zoom = camera_min_zoom
	fix_camera()

func orbit_camera(mouse_event):
	# TODO: pass event to sudo-joystick (and return velocity).
	# TODO: make sure no unnecessary calls are passed here when turret mode is off.
	var roll_x = -mouse_event.relative.y*camera_sensitivity
	var roll_y = -mouse_event.relative.x*camera_sensitivity
	camera_x = self.rotation_degrees.x
	camera_y = self.rotation_degrees.y
	# X local, Y global.
	self.rotate_y(deg2rad(roll_y))
	if camera_x + roll_x >= camera_vert_limit_deg:
		self.rotation_degrees.x = camera_vert_limit_deg
	elif camera_x + roll_x <= -camera_vert_limit_deg:
		self.rotation_degrees.x = -camera_vert_limit_deg
	else:
		self.rotate_object_local(Vector3(1,0,0), deg2rad(roll_x))

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
	$Camera.translation.z = camera_min_zoom+camera_chase_offset
	$Camera.translation.y = camera_vert_offset
	zoom_ticks = 0
	current_zoom = camera_min_zoom
	
func zoom_camera(mouse_event):
	if mouse_event.is_pressed():
		if mouse_event.button_index == BUTTON_WHEEL_UP and \
		current_zoom <= camera_max_zoom:
			zoom_ticks += 1
			current_zoom += camera_zoom_step*zoom_ticks
			$Camera.translation.z = current_zoom
		elif mouse_event.button_index == BUTTON_WHEEL_DOWN and \
		current_zoom >= camera_min_zoom and zoom_ticks > 0:
			current_zoom -= camera_zoom_step*zoom_ticks
			zoom_ticks -= 1
			$Camera.translation.z = current_zoom

