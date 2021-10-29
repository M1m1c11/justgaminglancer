extends Node

# Values.
var mouse_x = 0
var mouse_y = 0
var mouse_x_abs = 0
var mouse_y_abs = 0
# Objects.
var mouse_vector = Vector2(0,0)
var viewport_size = Vector2(1,1)
# Flags.

var LMB_held = false
var LMB_released = true
var mouse_on_viewport = true


# Nodes.
var camera_rig = Node
var player_ship_state = Node
var signals = Node
var ui = Node
var ui_button_turret = Node
var ui_controls_bar = Node

func _ready():
	# ============================ Initialize nodes ===========================
	camera_rig = get_node("/root/Cont/View/Main/Player_ship/Camera_rig")
	player_ship_state = get_node("/root/Cont/View/Main/State/Player_ship")
	signals = get_node("/root/Cont/View/Main/Input/Signals")
	ui = get_node("/root/Cont/UI")
	ui_controls_bar = get_node("/root/Cont/UI/Controls")
	ui_button_turret = get_node("/root/Cont/UI/Controls/Button_turret")
	# ============================ Connect signals ============================
	signals.connect("sig_mouse_on_viewport", self, "is_mouse_on_viewport")
	signals.connect("sig_viewport_update", self, "is_viewport_update")
	signals.connect("sig_quit_game", self, "is_quit_game")
	signals.connect("sig_turret_mode_on", self, "is_turret_mode_on")
	# =========================================================================
	
	# Initial value require for the mouse coords.
	viewport_size = OS.window_size
	
# TODO: Link a script for key shortcuts (like options).
func _input(event):

	# ==================== For events on 3D viewport ==========================
	# Mouse over 3D viewport.
	if mouse_on_viewport:
		# =========================== For mouse ===============================
		# Track the mouse position in +/-1, +/-1 viewport coordinates.
		if event is InputEventMouseMotion:
			mouse_x_abs = event.global_position.x
			mouse_y_abs = event.global_position.y
			mouse_x = clamp(((mouse_x_abs-viewport_size.x/2) \
				/ viewport_size.x*2), -1, 1)
			mouse_y = clamp(((mouse_y_abs-viewport_size.y/2) \
				/ viewport_size.y*2), -1, 1)
			mouse_vector = Vector2(mouse_x, mouse_y)
		
		# Mouse button held check. LMB_released is to reduce calls number.
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and LMB_released:
			LMB_released = false
			LMB_held = true
		
		# Mouse button released check. LMB_released is to reduce calls number.
		if not Input.is_mouse_button_pressed(BUTTON_LEFT) and not LMB_released:
			LMB_released = true
			LMB_held = false
		
		# Camera orbiting is in the camera script.
		
		# Camera zoom.
		if event is InputEventMouseButton and player_ship_state.turret_mode:
			camera_rig.zoom_camera(event)
		
		# ======================= For keyboard buttons =========================
		if event is InputEventKey:
			
			# ============================ UI Controls =========================
			# Mouse flight.
			if event.pressed and event.scancode == KEY_SPACE:
				if player_ship_state.mouse_flight:
					player_ship_state.mouse_flight = false
					signals.emit_signal("sig_mouse_flight_on", false)
				else:
					player_ship_state.mouse_flight = true
					signals.emit_signal("sig_mouse_flight_on", true)
			
			# TODO: Should also be accessible from other areas and windows.
			# Show toolbar.
			if event.pressed and event.scancode == KEY_BACKSPACE:
				if ui_controls_bar.visible:
					ui_controls_bar.visible = false
				else:
					ui_controls_bar.visible = true
					
			
			# Turret mode. UI shortcut. Signal is emitted by UI.
			if event.pressed and event.scancode == KEY_H:
				if not player_ship_state.turret_mode: 
					ui_button_turret.pressed = true
				else: ui_button_turret.pressed = false
			
			# ============================= Ship controls ======================
			# Accelerate forward.
			# TODO: unique signals for simultaneous action.
			if event.pressed and event.scancode == KEY_UP:
				signals.emit_signal("sig_accelerate", true)

			# Accelerate backward.
			if event.pressed and event.scancode == KEY_DOWN:
				signals.emit_signal("sig_accelerate", false)

			# Accelerate left sgtrafe.
			if event.pressed and event.scancode == KEY_A:
				signals.emit_signal("sig_accelerate", Vector3(1, 0, 0))

			# Accelerate right strafe.
			if event.pressed and event.scancode == KEY_D:
				signals.emit_signal("sig_accelerate", Vector3(-1, 0, 0))
			
			# Accelerate up strafe.
			if event.pressed and event.scancode == KEY_W:
				signals.emit_signal("sig_accelerate", Vector3(0, -1, 0))

			# Accelerate down strafe.
			if event.pressed and event.scancode == KEY_S:
				signals.emit_signal("sig_accelerate", Vector3(0, 1, 0))
			
			# Accelerate down strafe.
			if event.pressed and event.scancode == KEY_Z:
				if not player_ship_state.engine_kill: 
					player_ship_state.engine_kill = true
					signals.emit_signal("sig_engine_kill", true)
				else: 
					player_ship_state.engine_kill = false
					signals.emit_signal("sig_engine_kill", false)
	# =================== For events outside of 3D viewport ===================
	# Mouse not over 3D viewport.
	else:
		pass
		
	# ========================= For events anywhere ===========================
	if event is InputEventKey:
		
		# Quit the game.
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

#func _process(delta):
#	pass

#func _physics_process(delta):
#	pass

# ================================== Other ====================================

# ============================ Signal processing ==============================
# Check if viewport resized and get new values. Required for mouse coordinates.
func is_viewport_update():
	# For mouse coords.
	viewport_size = OS.window_size

# Check if we are hovering mouse over the control bar.
func is_mouse_on_viewport(flag):
	if flag: mouse_on_viewport = true
	else: mouse_on_viewport = false

func is_quit_game():
	get_tree().quit()

func is_turret_mode_on(flag):
	player_ship_state.turret_mode = flag

