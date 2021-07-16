extends Node

# ================================ Signals ====================================
signal engine_switched_on
signal engine_switched_off
# =============================================================================

var turret_mode = false
var mouse_viewport_flag = true
var mouse_x = 0
var mouse_y = 0
var viewport_size = Vector2(1,1)

func _ready():
	# ====================== Connect signals ==================================
	var hud = get_node("/root/Main/UI")
	hud.connect("mouse_on_UI", self, "mouse_on_UI")
	hud.connect("mouse_on_viewport", self, "mouse_on_viewport")
	hud.connect("update_viewport", self, "viewport_resized")
	hud.connect("quit_game_pressed", self, "quit_game")
	hud.connect("switch_to_turret", self, "camera_mode_turret")
	hud.connect("switch_to_chase", self, "camera_mode_chase")
	hud.connect("engine_switch_on", self, "engine_on")
	hud.connect("engine_switch_off", self, "engine_off")
	# =========================================================================

func _input(event):

	# ==================== For events on 3D viewport ==========================
	# Mouse over 3D viewport.
	if mouse_viewport_flag:
		
		# Track the mouse position in +/-1, +/-1 viewport coordinates.
		if event is InputEventMouseMotion:
			mouse_x = clamp(((event.global_position.x-viewport_size.x/2) \
				/ viewport_size.x*2), -1, 1)
			mouse_y = clamp(((event.global_position.y-viewport_size.y/2) \
				/ viewport_size.y*2), -1, 1)

		# Camera orbiting.
		# TODO: re-wire LMB to "joystick" actuator.
		if event is InputEventMouseMotion and turret_mode and \
			event.button_mask == BUTTON_MASK_LEFT:
			get_node("/root/Main/Player_ship/Camera_rig") \
				.orbit_camera(event)
			
		# Camera zoom.
		if event is InputEventMouseButton and turret_mode:
			get_node("/root/Main/Player_ship/Camera_rig") \
				.zoom_camera(event)

	# =================== For input outside of 3D viewport ====================
	# Mouse not over 3D viewport.
	else:
		pass
		
	# ========================= For events anywhere ===========================
	if event is InputEventKey:
		
		# Quit the game.
		if event.pressed and event.scancode == KEY_ESCAPE:
			quit_game()

#func _process(delta):
#	pass

#func _physics_process(delta):
#	pass

# ============================ Signal processing ==============================
# Check if viewport resized and get new values. Required for mouse coordinates.
func viewport_resized():
	viewport_size = get_viewport().size

# Check if we are hovering mouse over the control bar.
func mouse_on_UI():
	mouse_viewport_flag = false

func mouse_on_viewport():
	mouse_viewport_flag = true

func quit_game():
	get_tree().quit()

func camera_mode_turret():
	turret_mode = true
	get_node("/root/Main/Player_ship/Camera_rig").turret_camera()

func camera_mode_chase():
	turret_mode = false
	get_node("/root/Main/Player_ship/Camera_rig").fix_camera()

func engine_on():
	emit_signal("engine_switched_on")

func engine_off():
	emit_signal("engine_switched_off")
