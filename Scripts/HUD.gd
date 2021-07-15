extends CanvasLayer

signal mouse_on_UI
signal mouse_on_viewport
signal update_viewport

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = get_parent().get_node("Input_processing")
	var main = get_parent()
	var camera_rig = get_parent().get_node("Player_ship_origin/Camera_rig")
	$Viewport_main/Debug_panel_left/FPS.text = \
		str("FPS: ", main.fps)
	$Viewport_main/Debug_panel_left/Camera_x.text = \
		str("Camera x: ", camera_rig.camera_x)
	$Viewport_main/Debug_panel_left/Camera_y.text = \
		str("Camera y: ", camera_rig.camera_y)
	$Viewport_main/Debug_panel_left/Mouse_x.text = \
		str("Mouse x: ", input.mouse_x)
	$Viewport_main/Debug_panel_left/Mouse_y.text = \
		str("Mouse y: ", input.mouse_y)
	$Viewport_main/Debug_panel_left/Current_zoom.text = \
		str("Current zoom: ", camera_rig.current_zoom)



func _on_Viewport_main_mouse_entered():
	emit_signal("mouse_on_viewport")


func _on_Viewport_main_mouse_exited():
	emit_signal("mouse_on_UI")

func _on_Viewport_main_resized():
	emit_signal("update_viewport")
