extends Spatial

#TODO: make this scene instance to any object that is focused on in game.

# Values.
var camera_min_zoom = 0
var camera_max_zoom = 0
var current_zoom = 0
var camera_vert = 0
var camera_horiz = 0
var zoom_ticks = 0
# Chase camera positions.
var vert = 0
var horiz = 0
var velocity_factor = 0
# Objects.
var mouse_vector = Vector2(0,0)
# Nodes.
var cam_opts = Node
var input = Node
var ui = Node
var player_ship_state = Node
var signals = Node
var ship = Node
var ship_model = Node

func _ready():
	# ============================ Initialize nodes ===========================
	input = get_node("/root/Main/Input")
	cam_opts = get_node("/root/Main/Options/Camera")
	player_ship_state = get_node("/root/Main/State/Player_ship")
	# TODO: make reference to model universal.
	ship = get_parent()
	ship_model = get_node("../Ship_model")
	signals = get_node("/root/Main/Input/Signals")
	ui = get_node("/root/Main/UI")
	# ============================ Connect signals ============================
	signals.connect("sig_turret_mode_on", self, "is_turret_mode_on")
	# =========================================================================
	
	# Safeguards to prevent clipping.
	camera_min_zoom = ship.camera_horiz_offset
	camera_max_zoom = camera_min_zoom*cam_opts.camera_zoom_out_times
	# Puts camera at proper distance from the model at start.
	current_zoom = ship.camera_horiz_offset
	fix_camera()
	
func _process(delta):
	# Track the change in camera mode and update mouse vector when LMB is held.
	# When the mouse is released proceed with a little of inertia for smoothness.
	if player_ship_state.turret_mode and \
	(input.LMB_held or player_ship_state.mouse_flight):
		mouse_vector = input.mouse_vector
		orbit_camera(mouse_vector)
	elif player_ship_state.turret_mode and \
	(not input.LMB_held or not player_ship_state.mouse_flight):
		# Stop inertia at small value of the vector.
		if abs(mouse_vector.x) > 0.01:
			mouse_vector /= cam_opts.camera_inertia_factor
			yield(get_tree().create_timer(delta), "timeout")
			orbit_camera(mouse_vector)
	
	# Chase camera.
	if not player_ship_state.turret_mode and \
	(input.LMB_held or player_ship_state.mouse_flight):
		mouse_vector = input.mouse_vector
		chase_camera(mouse_vector, delta)\
	# Return to initial position.
	elif not player_ship_state.turret_mode and not \
	(input.LMB_held or player_ship_state.mouse_flight):
		mouse_vector = Vector2(0,0)
		chase_camera(mouse_vector, delta)
	
# ================================== Other ====================================
func orbit_camera(mv):
	# Compensate camera roll speed by camera altitude.
	var phi = abs(cos(self.rotation.x))
	var roll_vert = -mv.y*cam_opts.camera_sensitivity
	var roll_horiz = -mv.x*cam_opts.camera_sensitivity*phi
	camera_vert = self.rotation_degrees.x
	camera_horiz = self.rotation_degrees.y
	if camera_vert + roll_vert >= cam_opts.camera_turret_roll_vert_limit:
		self.rotation_degrees.x = cam_opts.camera_turret_roll_vert_limit
	elif camera_vert + roll_vert <= -cam_opts.camera_turret_roll_vert_limit:
		self.rotation_degrees.x = -cam_opts.camera_turret_roll_vert_limit
	else:
		self.rotate_object_local(Vector3(1,0,0), deg2rad(roll_vert))
	self.rotate_object_local(Vector3(0,1,0), deg2rad(roll_horiz))
	self.rotation.z = 0

func chase_camera(mv, delta):
	# Initial and final camera position.
	var init_tilt = Vector2($Camera.rotation.x, $Camera.rotation.y)
	var init_push = Vector2(0.0, 0.0)
	# $Camera.rotation.x - vertical, $Camera.rotation.y - horizontal
	# UP - DOWN
	if mv.y < 0:
		vert = -mv.y*cos(
			$Camera.rotation.x
			)/(ship.camera_chase_tilt_horiz_damp_up)
	else:
		vert = -mv.y*cos(
			$Camera.rotation.x
			)/(ship.camera_chase_tilt_horiz_damp_down)
	# LEFT - RIGHT
	if mv.x < 0:
		horiz = -mv.x*cos(
			$Camera.rotation.y
			)/(ship.camera_chase_tilt_vert_damp_left)
	else:
		horiz = -mv.x*cos(
			$Camera.rotation.y
			)/(ship.camera_chase_tilt_vert_damp_right)
			
	# FORWARD - velocity_factor
	velocity_factor = ship.ship_linear_velocity*0.1
	
	var fin_tilt = Vector2(vert, horiz)
	var fin_push = Vector2(velocity_factor, 0.0)
	var tmp_tilt = init_tilt.linear_interpolate(fin_tilt, delta
		*ship.camera_tilt_velocity_factor)
	var tmp_push = init_push.linear_interpolate(fin_push, delta
		*ship.camera_push_velocity_factor)
	
	# Prevent camera sliding forward
	if tmp_push.x < camera_min_zoom:
		tmp_push.x = camera_min_zoom+tmp_push.x
	$Camera.translation.z = tmp_push.x
	
	# Tilt motion
	$Camera.rotation.x = tmp_tilt.x
	$Camera.rotation.y = tmp_tilt.y
	self.rotation.x = -tmp_tilt.x
	self.rotation.y = -tmp_tilt.y

	

# Initial position for turret camera
func turret_camera():
	$Camera.translation.y = 0
	$Camera.translation.z = ship.camera_horiz_offset
	zoom_ticks = 0
	current_zoom = ship.camera_horiz_offset

# Initial position for chase camera
func fix_camera():
	self.rotation_degrees.x = 0
	self.rotation_degrees.y = 0
	self.rotation_degrees.z = 0
	$Camera.rotation_degrees.x = 0
	$Camera.rotation_degrees.y = 0
	$Camera.rotation_degrees.z = 0
	$Camera.translation.y = ship.camera_vert_offset
	$Camera.translation.z = ship.camera_horiz_offset
	zoom_ticks = 0
	current_zoom = ship.camera_horiz_offset
	
func zoom_camera(mouse_event):
	if mouse_event.is_pressed():
		if mouse_event.button_index == BUTTON_WHEEL_UP and \
		current_zoom <= camera_max_zoom:
			zoom_ticks += 1
			current_zoom += cam_opts.camera_zoom_step*zoom_ticks
			$Camera.translation.z = current_zoom
		elif mouse_event.button_index == BUTTON_WHEEL_DOWN and \
		current_zoom >= camera_min_zoom and zoom_ticks > 0:
			current_zoom -= cam_opts.camera_zoom_step*zoom_ticks
			zoom_ticks -= 1
			$Camera.translation.z = current_zoom

func is_turret_mode_on(flag):
	if flag:
		# Reset camera first.
		fix_camera()
		turret_camera()
	else:
		fix_camera()
