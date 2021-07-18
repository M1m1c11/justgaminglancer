extends CanvasLayer

#TODO: Scalable UI (control panel, texts, buttons, etc).

# Flags.
var update_debug_text_on = false
var viewport_size = Vector2(1,1)
# Nodes.
var camera_rig = Node
var debug = Node
var input = Node
var main = Node
var mouse_vector = Node
var signals = Node
var text_panel = Node

func _ready():
	# ============================ Initialize nodes ===========================
	camera_rig = get_node("/root/Main/Player_ship/Camera_rig")
	debug = get_node("Main3D/Debug")
	input = get_node("/root/Main/Input")
	main = get_node("/root/Main")	
	mouse_vector = get_node("Main3D/Debug/Mouse_vector")
	signals = get_node("/root/Main/Input/Signals")
	text_panel = get_node("Main3D/Text_panel")
	# =========================================================================
		
	# Initialize windows in switched off mode to match button states.
	debug.hide()
	text_panel.hide()

func _input(event):
	# Duplicated input listening function for the sake of mouse vector drawing.
	if event is InputEventMouseMotion and debug.visible:
		# Mouse vector positions.
		mouse_vector.points[0] = Vector2(viewport_size.x/2, viewport_size.y/2)
		mouse_vector.points[1] = Vector2(input.mouse_x_abs, input.mouse_y_abs)
	
func _process(_delta):
	if update_debug_text_on: update_debug_text()

# ================================== Other ====================================
func update_debug_text():
	debug.get_node("FPS").text = str("FPS: ", main.fps)
	debug.get_node("Camera_x").text = str("Camera x: ", camera_rig.camera_x)
	debug.get_node("Camera_y").text = str("Camera y: ", camera_rig.camera_y)
	debug.get_node("Mouse_x").text = str("Mouse x: ", input.mouse_x)
	debug.get_node("Mouse_y").text = str("Mouse y: ", input.mouse_y)
	debug.get_node("Current_zoom").text = str("Current zoom: ", camera_rig.current_zoom)

# ========================== Signals connections =============================
func _on_Viewport_main_mouse_entered():
	signals.emit_signal("sig_mouse_on_viewport", true)

func _on_Viewport_main_mouse_exited():
	signals.emit_signal("sig_mouse_on_viewport", false)

func _on_Viewport_main_resized():
	signals.emit_signal("sig_viewport_update")
	viewport_size = get_viewport().size
	
func _on_Button_quit_pressed():
	signals.emit_signal("sig_quit_game")

func _on_Button_turret_toggled(button_pressed):
	if button_pressed: signals.emit_signal("sig_turret_mode", true)
	else: signals.emit_signal("sig_turret_mode", false)

func _on_Button_debug_toggled(button_pressed):
	if button_pressed: 
		debug.show()
		update_debug_text_on = true
	else:
		debug.hide()
		update_debug_text_on = false

func _on_Button_text_panel_toggled(button_pressed):
	if button_pressed: text_panel.show()
	else: text_panel.hide()
	
func _on_Button_engine_toggled(button_pressed):
	if button_pressed: signals.emit_signal("sig_ship_engine", true)
	else: signals.emit_signal("sig_ship_engine", false)
