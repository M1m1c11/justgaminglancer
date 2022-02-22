extends CanvasLayer

#TODO: Scalable UI (control panel, texts, buttons, etc).

# Flags.
var stick_held = false
var touchscreen_mode = false
var update_debug_text_on = false
var viewport_size = Vector2(1,1)


# Nodes.
onready var p = get_tree().get_root().get_node("Container/Paths")
onready var controls = get_node("Controls")
onready var controls_touchscreen = get_node("Controls_touchscreen")
onready var gui_prompt = get_node("GUI_prompt")
onready var debug = get_node("Main3D/Debug")
onready var main3d = get_node("Main3D")
onready var marker = get_node("Main3D/Debug/Marker")
onready var marker2 = get_node("Main3D/Debug/Marker2")
onready var marker3 = get_node("Main3D/Debug/Marker3")
onready var mouse_vector = get_node("Main3D/Debug/Mouse_vector")
onready var mouse_area = get_node("Controls/Mouse_area")
onready var pad_base = get_node("Controls_touchscreen/Main_controls/Pad_base")
onready var stick = get_node("Controls_touchscreen/Main_controls/Pad_base/Stick")
onready var text_panel = get_node("Main3D/Text_panel")
onready var touchscreen_options = get_node("Controls_touchscreen/Options_menu")
onready var touchscreen_main = get_node("Controls_touchscreen/Main_controls")
onready var apparent_velocity = get_node("Main3D/Apparent_velocity")
onready var apparent_velocity_units = get_node("Main3D/Apparent_velocity_units")

func _ready():
	# Recenter the joystic according to GUI to prevent jumping.
	p.input.pad_x_abs = pad_base.rect_size.x/2
	p.input.pad_y_abs = pad_base.rect_size.x/2
	
	# Initialize windows in switched off mode to match button states.
	controls.hide()
	controls_touchscreen.hide()
	touchscreen_options.hide()
	mouse_area.hide() # TODO: Maybe not the best approach?
	main3d.hide()
	debug.hide()
	text_panel.hide()
	
	gui_prompt.show()
	

func _input(event):
	# Duplicated input listening function for the sake of mouse vector drawing.
	if event is InputEventMouseMotion and debug.visible:
		# Mouse vector positions.
		mouse_vector.points[0] = Vector2(viewport_size.x/2, viewport_size.y/2)
		mouse_vector.points[1] = Vector2(
				p.input.mouse_vector.x*viewport_size.x/2 + viewport_size.x/2, 
				p.input.mouse_vector.y*viewport_size.y/2 + viewport_size.y/2
			)
	
func _process(_delta):
	# Process virtual stick input.
	if touchscreen_mode:
		if stick_held:
			stick.rect_position.x = p.input.pad_x_abs-stick.rect_size.x/2
			stick.rect_position.y = p.input.pad_y_abs-stick.rect_size.y/2
		else:
			# Recenter stick.
			if stick.rect_position != Vector2(70,70):
				stick.rect_position = Vector2(
					pad_base.rect_size.x/2-stick.rect_size.x/2,
					pad_base.rect_size.y/2-stick.rect_size.y/2
				)
				# Reset stick input coords to prevent jumping.
				p.input.pad_x_abs = pad_base.rect_size.x/2
				p.input.pad_y_abs = pad_base.rect_size.y/2
				p.input.mouse_vector = Vector2(0,0)
	
	
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
	
	
	# TODO: distance_to fails at 1e9 units.
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
	debug.get_node("Mouse_x").text = str("Mouse / Pad x: ", p.input.mouse_vector.x)
	debug.get_node("Mouse_y").text = str("Mouse / Pad y: ", p.input.mouse_vector.y)
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
	elif (val >= 10000000000):
		return [val/10000000000, "Gu"]

# ========================== Signals connections =============================
# Setting up GUI on start.
# TOUCHSCREEN
func _on_Button_touchscreen_switch_pressed():
	touchscreen_mode = true
	# Main GUI elements.
	main3d.show()
	# Controls.
	controls_touchscreen.show()
	controls_touchscreen.get_node("Main_controls").show()
	controls_touchscreen.get_node("Main_controls/Slider_zoom").hide()
	# Hide prompt and disable irrelevant scheme.
	controls.hide()
	gui_prompt.hide()
	mouse_area.hide() # TODO: Maybe not the best approach?

# DESKTOP
func _on_Button_cumputer_gui_switch_pressed():
	touchscreen_mode = false
	# Main GUI elements.
	main3d.show()
	# Controls.
	controls.show()
	mouse_area.show() # TODO: Maybe not the best approach?
	# Hide prompt and disable irrelevant scheme.
	controls_touchscreen.hide()
	gui_prompt.hide()



# TODO: improve
func _on_Viewport_main_resized():
	# Has to be called manually bc "Paths/Signals" doesn't initiate at start.
	get_node("/root/Container/Signals").emit_signal("sig_viewport_update")
	viewport_size = OS.window_size
	
func _on_Button_quit_pressed():
	p.signals.emit_signal("sig_quit_game")

func _on_Button_turret_toggled(button_pressed):
	if button_pressed: 
		p.signals.emit_signal("sig_turret_mode_on", true)
		# Show slider in Touch GUI.
		if controls_touchscreen.visible:
			controls_touchscreen.get_node("Main_controls/Slider_zoom").show()
	else: 
		p.signals.emit_signal("sig_turret_mode_on", false)
		# Hide slider in Touch GUI.
		if controls_touchscreen.visible:
			controls_touchscreen.get_node("Main_controls/Slider_zoom").hide()

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



# Acceleration / decelartion
func _on_Button_accel_plus_pressed():
	p.signals.emit_signal("sig_accelerate", true)

func _on_Button_accel_minus_pressed():
	p.signals.emit_signal("sig_accelerate", false)

func _on_Button_ekill_toggled(button_pressed):
	if button_pressed: p.signals.emit_signal("sig_engine_kill", true)
	else: p.signals.emit_signal("sig_engine_kill", false)

# TODO: multitouch support

# Other buttons
func _on_Button_options_pressed():
	touchscreen_main.hide()
	touchscreen_options.show()
	
func _on_Button_close_options_pressed():
	touchscreen_main.show()
	touchscreen_options.hide()



# Mouse capturing for desktop.
func _on_Mouse_area_mouse_entered():
	p.signals.emit_signal("sig_mouse_on_viewport", true)

func _on_Mouse_area_mouse_exited():
	p.signals.emit_signal("sig_mouse_on_viewport", false)

func _on_Slider_zoom_value_changed(value):
	p.signals.emit_signal("sig_zoom_value_changed", value)



# Virtual stick.
func _on_Stick_button_down():
	stick_held = true

func _on_Stick_button_up():
	stick_held = false

