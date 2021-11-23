extends CanvasLayer

#TODO: Scalable UI (control panel, texts, buttons, etc).

# Flags.
var update_debug_text_on = false
var viewport_size = Vector2(1,1)


# Nodes.
var p = Node
var debug = Node
var marker = Node
var marker2 = Node
var marker3 = Node
var mouse_vector = Node
var text_panel = Node
var apparent_velocity = Node
var apparent_velocity_units = Node

func _ready():
	# ============================ Initialize nodes ===========================
	p = get_node("/root/Container/Paths")
	apparent_velocity = get_node("Controls/Apparent_velocity")
	apparent_velocity_units = get_node("Controls/Apparent_velocity_units")
	debug = get_node("Main3D/Debug")
	marker = get_node("Main3D/Debug/Marker")
	marker2 = get_node("Main3D/Debug/Marker2")
	marker3 = get_node("Main3D/Debug/Marker3")
	mouse_vector = get_node("Main3D/Debug/Mouse_vector")
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
		mouse_vector.points[1] = Vector2(p.input.mouse_x_abs, p.input.mouse_y_abs)
	
func _process(_delta):
	# TODO: make a system of spatial markers. Proper ones.
	# This should be an iterator over objects within proximity.
	var loc = p.camera_rig.global_transform.origin
	var loc_space = p.local_space.global_transform.origin
	#var loc2 = monolith.global_transform.origin
	
	# Origin. Multiply by scale factor of viewport.
	marker.visible = not p.viewport.get_camera().is_position_behind(loc_space)
	marker.rect_position = p.viewport.get_camera().unproject_position(
		loc_space)/p.viewport.screen_res_factor
	# TODO: properly align and center on the object.
	# Adjust displayed distance
	var dist_val = round(10*loc.distance_to(loc_space))
	var result_d = get_magnitude_units(dist_val)
	marker.get_node("Text").text = "Origin: "\
			+str(round(result_d[0]))+ " " + result_d[1]
	
	#marker2.visible = not get_viewport().get_camera().is_position_behind(loc2)
	#marker2.rect_position = get_viewport().get_camera().unproject_position(loc2)
	#marker2.text = "Monolith: "+str(loc.distance_to(loc2))
	
	if update_debug_text_on: update_debug_text()
	
	# Adjust displayed speed
	var speed_val = round(p.ship_state.apparent_velocity)
	var result_s = get_magnitude_units(speed_val)
	apparent_velocity.text = str(result_s[0])
	apparent_velocity_units.text = str(result_s[1])+"/s"

# ================================== Other ====================================
func update_debug_text():
	debug.get_node("FPS").text = str("FPS: ", p.global_space.fps)
	debug.get_node("Mouse_x").text = str("Mouse x: ", p.input.mouse_x)
	debug.get_node("Mouse_y").text = str("Mouse y: ", p.input.mouse_y)
	debug.get_node("Current_zoom").text = str("Current zoom: ", p.camera_rig.current_zoom)

func get_magnitude_units(val):
	# Val MUST BE IN DECIUNITS!
	# TODO: scale everything back to how it was and switch to units?
	if val < 10:
		return [val, "du"]
	elif (val >= 10) and (val < 10000):
		return [val/10, "u"]
	elif (val >= 10000) and (val < 10000000):
		return [val/10000, "ku"]
	elif (val >= 10000000) and (val < 10000000000):
		return [val/10000000, "Mu"]

# ========================== Signals connections =============================
func _on_Viewport_main_mouse_entered():
	p.signals.emit_signal("sig_mouse_on_viewport", true)

func _on_Viewport_main_mouse_exited():
	p.signals.emit_signal("sig_mouse_on_viewport", false)

# TODO: improve
func _on_Viewport_main_resized():
	# Has to be called manually bc "Paths/Signals" doesn't initiate at start.
	get_node("/root/Container/Signals").emit_signal("sig_viewport_update")
	viewport_size = OS.window_size
	
func _on_Button_quit_pressed():
	p.signals.emit_signal("sig_quit_game")

func _on_Button_turret_toggled(button_pressed):
	if button_pressed: p.signals.emit_signal("sig_turret_mode_on", true)
	else: p.signals.emit_signal("sig_turret_mode_on", false)

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
	if button_pressed: p.signals.emit_signal("sig_screen_filter_on", true)
	else: p.signals.emit_signal("sig_screen_filter_on", false)

func _on_Slider_screen_res_value_changed(value):
	p.signals.emit_signal("sig_screen_res_value_changed", value)

func _on_Slider_fov_value_changed(value):
	p.signals.emit_signal("sig_fov_value_changed", value)
