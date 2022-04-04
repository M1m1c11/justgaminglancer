extends CanvasLayer

#TODO: Scalable UI (control panel, texts, buttons, etc).

# VARIABLES
var stick_held = false
var turret_view = false
var touchscreen_mode = false
var update_debug_text_on = false
var ui_hidden = false
var ui_alpha = 1.0
var viewport_size = Vector2(1,1)

onready var p = get_tree().get_root().get_node("Container/Paths")

onready var mouse_vector_debug = p.ui.get_node("Main3D/Debug/Mouse_vector")

onready var touchscreen_buttons = p.ui.get_node("Controls_touchscreen/Main_controls/Touch_buttons_container")
onready var apparent_velocity = p.ui.get_node("Main3D/Apparent_velocity")
onready var apparent_velocity_units = p.ui.get_node("Main3D/Apparent_velocity_units")


onready var pad_base = p.ui.get_node("Controls_touchscreen/Main_controls/Pad_base")
onready var stick = p.ui.get_node("Controls_touchscreen/Main_controls/Pad_base/Stick")

func _ready():

	p.ui_pad.pad_recenter_stick()
	p.ui_windows.init_gui()
	

	
	
	

func _input(event):

	# Duplicated input listening function for the sake of mouse vector drawing.
	if event is InputEventMouseMotion and p.ui_windows.debug.visible:
		# Mouse vector positions.
		mouse_vector_debug.points[0] = Vector2(viewport_size.x/2, viewport_size.y/2)
		mouse_vector_debug.points[1] = Vector2(
				p.input.mouse_vector.x*viewport_size.x/2 + viewport_size.x/2, 
				p.input.mouse_vector.y*viewport_size.y/2 + viewport_size.y/2
			)
	
func _process(_delta):

	#p.ui_pad.pad_handle_stick()
	
		# Process virtual stick input.
	if p.ui.touchscreen_mode:
		if p.ui.stick_held:
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
	
	p.ui_markers.update_markers()
	
	# DEBUG
	if update_debug_text_on: update_debug_text()
	
	# READOUTS
	# Adjust displayed speed
	var speed_val = round(p.ship_state.apparent_velocity)
	var result_s = p.ui_readouts.get_magnitude_units(speed_val)
	apparent_velocity.text = str(result_s[0])
	apparent_velocity_units.text = str(result_s[1])+"/s"
	p.ui_windows.main3d.get_node("Accel_ticks").text = str("Accel. ticks: ", p.ship_state.accel_ticks)

# ================================== Other ====================================
# DEBUG
func update_debug_text():
	p.ui_windows.debug.get_node("FPS").text = str("FPS: ", p.global_space.fps)
	p.ui_windows.debug.get_node("Mouse_x").text = str("Mouse / Pad x: ", p.input.mouse_vector.x)
	p.ui_windows.debug.get_node("Mouse_y").text = str("Mouse / Pad y: ", p.input.mouse_vector.y)



# SIGNAL PROCESSING
# TODO: sort out

# Setting up GUI on start.
# TOUCHSCREEN

# UI SWITCHING
func _on_Button_touchscreen_switch_pressed():
	touchscreen_mode = true
	# Main GUI elements.
	p.ui_windows.main3d.show()
	# Controls.
	p.ui_windows.controls_touchscreen.show()
	p.ui_windows.controls_touchscreen.get_node("Main_controls").show()
	p.ui_windows.controls_touchscreen.get_node("Main_controls/Slider_zoom").hide()
	# Hide prompt and disable irrelevant scheme.
	p.ui_windows.controls.hide()
	p.ui_windows.gui_prompt.hide()
	p.ui_windows.mouse_area.hide() # TODO: Maybe not the best approach?

# DESKTOP
# UI SWITCHING
func _on_Button_cumputer_gui_switch_pressed():
	touchscreen_mode = false
	# Main GUI elements.
	p.ui_windows.main3d.show()
	# Controls.
	p.ui_windows.controls.show()
	p.ui_windows.mouse_area.show() # TODO: Maybe not the best approach?
	# Hide prompt and disable irrelevant scheme.
	p.ui_windows.controls_touchscreen.hide()
	p.ui_windows.gui_prompt.hide()



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
		if p.ui_windows.controls_touchscreen.visible:
			p.ui_windows.controls_touchscreen.get_node("Main_controls/Slider_zoom").show()
	else: 
		p.signals.emit_signal("sig_turret_mode_on", false)
		# Hide slider in Touch GUI.
		if p.ui_windows.controls_touchscreen.visible:
			p.ui_windows.controls_touchscreen.get_node("Main_controls/Slider_zoom").hide()

# DESKTOP / MOBILE GUI
func _on_Button_debug_toggled(button_pressed):
	if button_pressed: 
		p.ui_windows.debug.show()
		update_debug_text_on = true
	else:
		p.ui_windows.debug.hide()
		update_debug_text_on = false

# DESKTOP / MOBILE GUI
func _on_Button_text_panel_toggled(button_pressed):
	if button_pressed: p.ui_windows.text_panel.show()
	else: p.ui_windows.text_panel.hide()

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
	p.ui_windows.touchscreen_main.hide()
	p.ui_windows.touchscreen_options.show()
	
func _on_Button_close_options_pressed():
	p.ui_windows.touchscreen_main.show()
	p.ui_windows.touchscreen_options.hide()



# Mouse capturing for desktop.
# Keep here
func _on_Mouse_area_mouse_entered():
	p.signals.emit_signal("sig_mouse_on_control_area", true)

func _on_Mouse_area_mouse_exited():
	p.signals.emit_signal("sig_mouse_on_control_area", false)

# DESKTOP / MOBILE GUI
func _on_Slider_zoom_value_changed(value):
	p.signals.emit_signal("sig_zoom_value_changed", value)


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
	p.ui_windows.touchscreen_main.modulate.a = ui_alpha
	p.ui_windows.main3d.modulate.a = ui_alpha
	ui_alpha -= 0.25
	if ui_alpha < 0.0:
		ui_alpha = 1.0

# DESKTOP / MOBILE GUI
func _on_Button_ekill_pressed():
	p.signals.emit_signal("sig_engine_kill")

