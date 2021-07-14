extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var main = get_parent()
	$Debug_panel/FPS.text = str("FPS: ", main.fps)
	$Debug_panel/Camera_x.text = str("Camera x: ", main.camera_x)
	$Debug_panel/Camera_y.text = str("Camera y: ", main.camera_y)
	$Debug_panel/Mouse_x.text = str("Mouse x: ", main.mouse_x)
	$Debug_panel/Mouse_y.text = str("Mouse y: ", main.mouse_y)
