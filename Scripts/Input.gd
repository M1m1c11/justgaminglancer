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
var turret_mode = false
# Nodes.
var camera_rig = Node
var ui = Node
var ui_button_turret = Node
var signals = Node

func _ready():
	# ============================ Initialize nodes ===========================
	camera_rig = get_node("/root/Main/Player_ship/Camera_rig")
	signals = get_node("/root/Main/Input/Signals")
	ui = get_node("/root/Main/UI")
	ui_button_turret = get_node("/root/Main/UI/Controls/Button_turret")
	# ============================ Connect signals ============================
	signals.connect("sig_mouse_on_viewport", self, "is_mouse_on_viewport")
	signals.connect("sig_viewport_update", self, "is_viewport_update")
	signals.connect("sig_quit_game", self, "is_quit_game")
	signals.connect("sig_turret_mode", self, "is_turret_mode_on")
	# =========================================================================
	
	# Initial value require for the mouse coords.
	viewport_size = get_viewport().size
	
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
			signals.emit_signal("sig_LMB_held", true)
		
		# Mouse button released check. LMB_released is to reduce calls number.
		if not Input.is_mouse_button_pressed(BUTTON_LEFT) and not LMB_released:
			LMB_released = true
			signals.emit_signal("sig_LMB_held", false)
		
		# Camera orbiting is in the camera script.
		
		# Camera zoom.
		if event is InputEventMouseButton and turret_mode:
			camera_rig.zoom_camera(event)
		
		# ======================= For keyboard buttons ========================
		# TODO: Implement "mouse flight"-like thing that will ignore control bar mouse focus.
		if event is InputEventKey:
			if event.pressed and event.scancode == KEY_SPACE:
				# TODO: emit signal
				pass
				
			if event.pressed and event.scancode == KEY_H:
				# TODO: emit signal
				if not turret_mode:
					turret_mode = true
					ui_button_turret.pressed = true

				else:
					turret_mode = false
					ui_button_turret.pressed = false

				
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
	viewport_size = get_viewport().size

# Check if we are hovering mouse over the control bar.
func is_mouse_on_viewport(flag):
	if flag: mouse_on_viewport = true
	else: mouse_on_viewport = false

func is_quit_game():
	get_tree().quit()

func is_turret_mode_on(flag):
	if flag: turret_mode = true
	else: turret_mode = false
