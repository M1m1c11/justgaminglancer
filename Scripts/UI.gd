extends CanvasLayer

#TODO: Scalable UI (control panel, texts, buttons, etc).

# Flags.
var stick_held = false
var turret_view = false
var touchscreen_mode = false
var update_debug_text_on = false
var ui_hidden = false
var ui_alpha = 1.0
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
onready var mouse_vector_debug = get_node("Main3D/Debug/Mouse_vector")
onready var mouse_area = get_node("Controls/Mouse_area")
onready var pad_base = get_node("Controls_touchscreen/Main_controls/Pad_base")
onready var stick = get_node("Controls_touchscreen/Main_controls/Pad_base/Stick")
onready var text_panel = get_node("Main3D/Text_panel")
onready var touchscreen_options = get_node("Controls_touchscreen/Options_menu")
onready var touchscreen_main = get_node("Controls_touchscreen/Main_controls")
onready var touchscreen_buttons = get_node("Controls_touchscreen/Main_controls/Touch_buttons_container")
onready var apparent_velocity = get_node("Main3D/Apparent_velocity")
onready var apparent_velocity_units = get_node("Main3D/Apparent_velocity_units")

func _ready():
	# PAD
	# Recenter the joystic according to GUI to prevent jumping.
	p.input_pad.pad_x_abs = pad_base.rect_size.x/2
	p.input_pad.pad_y_abs = pad_base.rect_size.x/2
	
	
	# INIT
	# Initialize windows in switched off mode to match button states.
	gui_prompt.hide()
	gui_prompt.show()
	
	controls.hide()
	controls_touchscreen.hide()
	touchscreen_options.hide()
	mouse_area.hide() # TODO: Maybe not the best approach?
	main3d.hide()
	debug.hide()
	text_panel.hide()
	
	
	

func _input(event):

	# Duplicated input listening function for the sake of mouse vector drawing.
	if event is InputEventMouseMotion and debug.visible:
		# Mouse vector positions.
		mouse_vector_debug.points[0] = Vector2(viewport_size.x/2, viewport_size.y/2)
		mouse_vector_debug.points[1] = Vector2(
				p.input.mouse_vector.x*viewport_size.x/2 + viewport_size.x/2, 
				p.input.mouse_vector.y*viewport_size.y/2 + viewport_size.y/2
			)
	
func _process(_delta):
	# PAD
	# Process virtual stick input.
	if touchscreen_mode:
		if stick_held:
			stick.position.x = p.input_pad.pad_x_abs-100
			stick.position.y = p.input_pad.pad_y_abs-100
		else:
			# Recenter stick.
			if stick.position != Vector2(70,70):
				stick.position = Vector2(
					pad_base.rect_size.x/2-100,
					pad_base.rect_size.y/2-100
				)
				# Reset stick input coords to prevent jumping.
				p.input_pad.pad_x_abs = pad_base.rect_size.x/2
				p.input_pad.pad_y_abs = pad_base.rect_size.y/2
				p.input.mouse_vector = Vector2(0,0)
	
	# MARKER
	# TODO: make a system of spatial markers. Proper ones.
	# This should be an iterator over objects within proximity.
	var loc = p.camera_rig.global_transform.origin
	var loc_cube = p.cube.global_transform.origin
	#var loc2 = monolith.global_transform.origin
	
	# Origin. Multiply by scale factor of viewport.
	marker.visible = not p.viewport.get_camera().is_position_behind(loc_cube)
	marker.rect_position = p.viewport.get_camera().unproject_position(
		loc_cube)/p.viewport_opts.screen_res_factor
	# TODO: properly align and center on the object.
	# Adjust displayed distance
	
	
	# TODO: distance_to fails at 1e9 units.
	var dist_val = round(10*loc.distance_to(loc_cube))
	var result_d = get_magnitude_units(dist_val)
	marker.get_node("Text").text = "Origin: "\
			+str(round(result_d[0]))+ " " + result_d[1]

	
	#marker2.visible = not get_viewport().get_camera().is_position_behind(loc2)
	#marker2.rect_position = get_viewport().get_camera().unproject_position(loc2)
	#marker2.text = "Monolith: "+str(loc.distance_to(loc2))
	
	# DEBUG
	if update_debug_text_on: update_debug_text()
	
	# READOUTS
	# Adjust displayed speed
	var speed_val = round(p.ship_state.apparent_velocity)
	var result_s = get_magnitude_units(speed_val)
	apparent_velocity.text = str(result_s[0])
	apparent_velocity_units.text = str(result_s[1])+"/s"
	main3d.get_node("Accel_ticks").text = str("Accel. ticks: ", p.ship_state.accel_ticks)

# ================================== Other ====================================
# DEBUG
func update_debug_text():
	debug.get_node("FPS").text = str("FPS: ", p.global_space.fps)
	debug.get_node("Mouse_x").text = str("Mouse / Pad x: ", p.input.mouse_vector.x)
	debug.get_node("Mouse_y").text = str("Mouse / Pad y: ", p.input.mouse_vector.y)

# READOUTS
func get_magnitude_units(val):
	# Val MUST BE IN DECIUNITS!
	# TODO: scale everything back to how it was and switch to units?
	if val < 10:
		return [round(val), "du"]
	elif (val >= 10) and (val < 10000):
		return [round(val/10), "u"]
	elif (val >= 10000) and (val < 10000000):
		return [round(val/10000), "ku"]
	elif (val >= 10000000) and (val < 10000000000):
		return [round(val/10000000), "Mu"]
	elif (val >= 10000000000):
		return [round(val/10000000000), "Gu"]

# SIGNAL PROCESSING
# TODO: sort out

# Setting up GUI on start.
# TOUCHSCREEN

# UI SWITCHING
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
# UI SWITCHING
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
# Keep here
func _on_Viewport_main_resized():
	# Has to be called manually bc "Paths/Signals" doesn't initiate at start.
	get_node("/root/Container/Signals").emit_signal("sig_viewport_update")
	viewport_size = OS.window_size

# DESKTOP / MOBILE GUI
func _on_Button_quit_pressed():
	p.signals.emit_signal("sig_quit_game")

# DESKTOP / MOBILE GUI
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

# DESKTOP / MOBILE GUI
func _on_Button_debug_toggled(button_pressed):
	if button_pressed: 
		debug.show()
		update_debug_text_on = true
	else:
		debug.hide()
		update_debug_text_on = false

# DESKTOP / MOBILE GUI
func _on_Button_text_panel_toggled(button_pressed):
	if button_pressed: text_panel.show()
	else: text_panel.hide()

# DESKTOP / MOBILE GUI
func _on_Button_screen_filter_toggled(button_pressed):
	if button_pressed: p.signals.emit_signal("sig_screen_filter_on", true)
	else: p.signals.emit_signal("sig_screen_filter_on", false)

# DESKTOP / MOBILE GUI
func _on_Slider_screen_res_value_changed(value):
	p.signals.emit_signal("sig_screen_res_value_changed", value)

# DESKTOP / MOBILE GUI
func _on_Slider_fov_value_changed(value):
	p.signals.emit_signal("sig_fov_value_changed", value)


# DESKTOP / MOBILE GUI
# Acceleration / decelartion
func _on_Button_accel_plus_pressed():
	p.signals.emit_signal("sig_accelerate", true)
	
# DESKTOP / MOBILE GUI
func _on_Button_accel_minus_pressed():
	p.signals.emit_signal("sig_accelerate", false)

# DESKTOP / MOBILE GUI
# Other buttons
func _on_Button_options_pressed():
	touchscreen_main.hide()
	touchscreen_options.show()
	
func _on_Button_close_options_pressed():
	touchscreen_main.show()
	touchscreen_options.hide()



# Mouse capturing for desktop.
# Keep here
func _on_Mouse_area_mouse_entered():
	p.signals.emit_signal("sig_mouse_on_control_area", true)

func _on_Mouse_area_mouse_exited():
	p.signals.emit_signal("sig_mouse_on_control_area", false)

# DESKTOP / MOBILE GUI
func _on_Slider_zoom_value_changed(value):
	p.signals.emit_signal("sig_zoom_value_changed", value)


# PAD
# Virtual stick.
func _on_Stick_pressed():
	stick_held = true

func _on_Stick_released():
	stick_held = false



# DESKTOP / MOBILE GUI
# Touchscreen controls.
func _on_Touch_accel_plus_pressed():
	p.signals.emit_signal("sig_accelerate", true)

func _on_Touch_accel_minus_pressed():
	p.signals.emit_signal("sig_accelerate", false)

func _on_Touch_ekill_pressed():
	p.signals.emit_signal("sig_engine_kill")



# DESKTOP / MOBILE GUI
func _on_Button_hide_ui_pressed():
	touchscreen_main.modulate.a = ui_alpha
	main3d.modulate.a = ui_alpha
	ui_alpha -= 0.25
	if ui_alpha < 0.0:
		ui_alpha = 1.0

# DESKTOP / MOBILE GUI
func _on_Button_ekill_pressed():
	p.signals.emit_signal("sig_engine_kill")

