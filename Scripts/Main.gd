extends Spatial


# Declare member variables here. Examples:
var mouse_sens = 0.2
var camera_x_limit = 50 #deg

export var camera_x = 0
export var camera_y = 0
export var mouse_x = 0
export var mouse_y = 0
export var fps = 0
export var viewport_size_x = 0
export var viewport_size_y = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	# Camera movement.
	# TODO: swap this to joystic-like thing and after that connect with cam.
	if event is InputEventMouseMotion and event.button_mask == BUTTON_MASK_LEFT:
		var roll_x = -event.relative.y*mouse_sens
		var roll_y = -event.relative.x*mouse_sens
		camera_x = $Player_ship_origin/Camera_rig.rotation_degrees.x
		camera_y = $Player_ship_origin/Camera_rig.rotation_degrees.y
		viewport_size_x = get_viewport().size.x
		viewport_size_y = get_viewport().size.y
		mouse_x = clamp(((event.global_position.x-viewport_size_x/2)/viewport_size_x*2), -1, 1)
		mouse_y = clamp(((event.global_position.y-viewport_size_y/2)/viewport_size_y*2), -1, 1)
		# X local, Y global.
		$Player_ship_origin/Camera_rig.rotate_y(deg2rad(roll_y))
		# Lower camera position limit.
		if camera_x + roll_x >= camera_x_limit:
			$Player_ship_origin/Camera_rig.rotation_degrees.x = camera_x_limit
		# Upper camera position limit.
		elif camera_x + roll_x <= -camera_x_limit:
			$Player_ship_origin/Camera_rig.rotation_degrees.x = -camera_x_limit
		else:
			$Player_ship_origin/Camera_rig.rotate_object_local(Vector3(1,0,0), deg2rad(roll_x))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps = Engine.get_frames_per_second()
