extends Node

# Variable inits
var mouse_viewport_flag = true
var mouse_x = 0
var mouse_y = 0
var fps = 0
var viewport_size = Vector2(1,1)


# Called when the node enters the scene tree for the first time. Inits.
func _ready():
	# ====================== Connect signals ==================================
	var hud = get_parent().get_node("HUD")
	hud.connect("mouse_on_UI", self, "mouse_on_UI")
	hud.connect("mouse_on_viewport", self, "mouse_on_viewport")
	hud.connect("update_viewport", self, "viewport_resized")
	# =========================================================================

# Input event processing.
func _input(event):

	# ==================== For events on 3D viewport ==========================
	# This is ususally related to mouse events.
	if mouse_viewport_flag:
		
		# Track the mouse position in +/-1, +/-1 viewport coordinates.
		mouse_x = clamp(((event.global_position.x-viewport_size.x/2) \
			/ viewport_size.x*2), -1, 1)
		mouse_y = clamp(((event.global_position.y-viewport_size.y/2) \
			/ viewport_size.y*2), -1, 1)

		# Camera orbiting.
		if event is InputEventMouseMotion and \
		 	event.button_mask == BUTTON_MASK_LEFT:
			get_parent().get_node("Player_ship_origin/Camera_rig") \
				.orbit_camera(event)
			
		# Camera zoom.
		if event is InputEventMouseButton:
			get_parent().get_node("Player_ship_origin/Camera_rig") \
				.zoom_camera(event)

	# =================== For input outside of 3D viewport ====================
	# This is related to mouse events over widows and menus.
	# There is no need to track the mouse in those, unless there are
	# additional viewports created later on. This would require making another
	# falgs?
	else:
		pass
		
	# ========================== Keyboard keys ================================
	if event is InputEventKey:
		
		# Quit the game.
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Every physics frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	pass


# ============================ SIGNAL PROCESSING ==============================
# Check if viewport resized and get new values. Required for mouse coordinates.
func viewport_resized():
	viewport_size = get_viewport().size

# Check if we are hovering mouse over the control bar.
func mouse_on_UI():
	mouse_viewport_flag = false

func mouse_on_viewport():
	mouse_viewport_flag = true
