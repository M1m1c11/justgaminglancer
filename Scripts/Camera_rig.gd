extends Spatial

# ============================== Parameters ===================================
export var mouse_sens = 0.3 # 0.1 ... 0.5
export var camera_x_limit = 70 # Deg +\-
export var camera_zoom_max_f = 3 # Times ship's bounding box axis length.
export var camera_zoom_step = 0.1 # 0.05 ... 0.2
# =============================================================================

var camera_min_zoom = 0
var camera_max_zoom = 0
var camera_zoom_increment = 1
var current_zoom = 0
var camera_x = 0
var camera_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Put camera at proper distance.
	camera_min_zoom = get_parent() \
		.get_node("Rogue_fighter/Ship_model") \
		.get_aabb().get_longest_axis_size()
	camera_max_zoom = camera_min_zoom*camera_zoom_max_f
	current_zoom = camera_min_zoom
	$Camera.translation.z = camera_min_zoom


func orbit_camera(mouse_event):
	var roll_x = -mouse_event.relative.y*mouse_sens
	var roll_y = -mouse_event.relative.x*mouse_sens
	camera_x = self.rotation_degrees.x
	camera_y = self.rotation_degrees.y
	# X local, Y global.
	self.rotate_y(deg2rad(roll_y))
	if camera_x + roll_x >= camera_x_limit:
		self.rotation_degrees.x = camera_x_limit
	elif camera_x + roll_x <= -camera_x_limit:
		self.rotation_degrees.x = -camera_x_limit
	else:
		self.rotate_object_local(Vector3(1,0,0), deg2rad(roll_x))

func zoom_camera(mouse_event):
	if mouse_event.is_pressed():
		if mouse_event.button_index == BUTTON_WHEEL_UP and \
		current_zoom <= camera_max_zoom:
			current_zoom += camera_zoom_step*current_zoom
			$Camera.translation.z = current_zoom
			print(camera_zoom_increment)
		elif mouse_event.button_index == BUTTON_WHEEL_DOWN and \
		current_zoom >= camera_min_zoom:
			current_zoom -= camera_zoom_step*current_zoom
			$Camera.translation.z = current_zoom
			print(camera_zoom_increment)
