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
var marker = Node
var marker2 = Node
var marker3 = Node
#var monolith = Node
#var monolith2 = Node
var mouse_vector = Node
var signals = Node
var text_panel = Node
var viewport = Node
var apparent_velocity = Node
var ship_state = Node
var local_space = Node

func _ready():
	# ============================ Initialize nodes ===========================
	apparent_velocity = get_node("Controls/Apparent_velocity")
	camera_rig = get_node("/root/Cont/View/Main/Ship/Camera_rig")
	debug = get_node("Main3D/Debug")
	input = get_node("/root/Cont/View/Main/Input")
	local_space = get_node("/root/Cont/View/Main/Local_space")
	main = get_node("/root/Cont/View/Main")
	marker = get_node("Main3D/Debug/Marker")
	marker2 = get_node("Main3D/Debug/Marker2")
	marker3 = get_node("Main3D/Debug/Marker3")
	ship_state = get_node("/root/Cont/View/Main/Ship/Ship_state")
	#monolith = get_node("/root/Cont/View/Main/Local_space/System_objects/Monolith")
	mouse_vector = get_node("Main3D/Debug/Mouse_vector")
	signals = get_node("/root/Cont/View/Main/Input/Signals")
	text_panel = get_node("Main3D/Text_panel")
	viewport = get_node("/root/Cont/View")
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
	# TODO: make a system of spatial markers. Proper ones.
	# This should be an iterator over objects within proximity.
	var loc = camera_rig.global_transform.origin
	var loc_space = local_space.global_transform.origin
	#var loc2 = monolith.global_transform.origin
	
	# Origin. Multiply by scale factor of viewport.
	marker.visible = not viewport.get_camera().is_position_behind(loc_space)
	marker.rect_position = viewport.get_camera().unproject_position(
		loc_space)/viewport.screen_res_factor
	# TODO: properly align and center on the object.
	marker.get_node("Text").text = "Origin: "+str(round(10*loc.distance_to(loc_space)))+ " du"
	
	#marker2.visible = not get_viewport().get_camera().is_position_behind(loc2)
	#marker2.rect_position = get_viewport().get_camera().unproject_position(loc2)
	#marker2.text = "Monolith: "+str(loc.distance_to(loc2))
	
	if update_debug_text_on: update_debug_text()
	
	apparent_velocity.text = str(round(ship_state.apparent_velocity))

# ================================== Other ====================================
func update_debug_text():
	debug.get_node("FPS").text = str("FPS: ", main.fps)
	debug.get_node("Mouse_x").text = str("Mouse x: ", input.mouse_x)
	debug.get_node("Mouse_y").text = str("Mouse y: ", input.mouse_y)
	debug.get_node("Current_zoom").text = str("Current zoom: ", camera_rig.current_zoom)

# ========================== Signals connections =============================
func _on_Viewport_main_mouse_entered():
	signals.emit_signal("sig_mouse_on_viewport", true)

func _on_Viewport_main_mouse_exited():
	signals.emit_signal("sig_mouse_on_viewport", false)

# TODO: improve
func _on_Viewport_main_resized():
	signals.emit_signal("sig_viewport_update")
	viewport_size = OS.window_size
	
func _on_Button_quit_pressed():
	signals.emit_signal("sig_quit_game")

func _on_Button_turret_toggled(button_pressed):
	if button_pressed: signals.emit_signal("sig_turret_mode_on", true)
	else: signals.emit_signal("sig_turret_mode_on", false)

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

func _on_Button_screen_filter_toggled(button_pressed):
	if button_pressed: signals.emit_signal("sig_screen_filter_on", true)
	else: signals.emit_signal("sig_screen_filter_on", false)

func _on_Slider_screen_res_value_changed(value):
	signals.emit_signal("sig_screen_res_value_changed", value)

func _on_Slider_fov_value_changed(value):
	signals.emit_signal("sig_fov_value_changed", value)
