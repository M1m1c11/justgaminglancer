extends CanvasLayer

#TODO: Scalable UI (control panel, texts, buttons, etc).

# ================================ Signals ====================================
signal mouse_on_UI
signal mouse_on_viewport
signal update_viewport
signal quit_game_pressed
signal switch_to_turret
signal switch_to_chase
signal engine_switch_on
signal engine_switch_off
# =============================================================================

var debug_left_dispaly = false
var text_right_display = false
# Nodes.
var main = Node
var input = Node
var camera_rig = Node

func _ready():
	# Initialize nodes instances.
	main = get_node("/root/Main")
	input = get_node("/root/Main/Input")
	camera_rig = get_node("/root/Main/Player_ship/Camera_rig")
		
func _process(delta):
	# Left debug display refresh.
	if debug_left_dispaly:
		$Main3D/Debug_left.show()
		$Main3D/Debug_left/FPS.text = str("FPS: ", main.fps)
		$Main3D/Debug_left/Camera_x.text = str("Camera x: ", camera_rig.camera_x)
		$Main3D/Debug_left/Camera_y.text = str("Camera y: ", camera_rig.camera_y)
		$Main3D/Debug_left/Mouse_x.text = str("Mouse x: ", input.mouse_x)
		$Main3D/Debug_left/Mouse_y.text = str("Mouse y: ", input.mouse_y)
		$Main3D/Debug_left/Current_zoom.text = \
			str("Current zoom: ", camera_rig.current_zoom)
	else: $Main3D/Debug_left.hide()
	
	# Right text panel switching.
	if text_right_display: $Main3D/Text_right.show()
	else: $Main3D/Text_right.hide()

# ========================== Signals connections =============================
func _on_Viewport_main_mouse_entered():
	emit_signal("mouse_on_viewport")

func _on_Viewport_main_mouse_exited():
	emit_signal("mouse_on_UI")

func _on_Viewport_main_resized():
	emit_signal("update_viewport")
	
func _on_Button_quit_pressed():
	emit_signal("quit_game_pressed")

func _on_Button_turret_toggled(button_pressed):
	if button_pressed: emit_signal("switch_to_turret")
	else: emit_signal("switch_to_chase")

func _on_Button_debug_toggled(button_pressed):
	debug_left_dispaly = button_pressed

func _on_Button_text_panel_toggled(button_pressed):
	text_right_display = button_pressed
	
func _on_Button_engine_toggled(button_pressed):
	if button_pressed: emit_signal("engine_switch_on")
	else: emit_signal("engine_switch_off")
# ============================================================================

