extends Node

onready var p = get_tree().get_root().get_node("Main/Paths")

onready var object_name = ""
onready var object_origin = p.ship.global_transform.origin
onready var player = p.camera_rig.global_transform.origin

var dist_val = 0
var target_controls_hidden = true

func _ready():
	# ============================= Connect signals ===========================
	p.signals.connect("sig_target_clear", self, "is_target_clear")
	# =========================================================================
	# Hide targeting bracked by default,
	p.ui_paths.target.hide()
	p.ui_paths.desktop_button_target_clear.hide()
	p.ui_paths.desktop_button_autopilot_start.hide()
	p.ui_paths.touchscreen_button_target_clear.hide()
	p.ui_paths.touchscreen_button_autopilot_start.hide()

func _physics_process(_delta):
	
	if  p.ship_state.aim_target_locked:	
		
		if target_controls_hidden:
			p.ui_paths.target.show()
			p.ui_paths.desktop_button_target_clear.show()
			p.ui_paths.desktop_button_autopilot_start.show()
			p.ui_paths.touchscreen_button_target_clear.show()
			p.ui_paths.touchscreen_button_autopilot_start.show()
			target_controls_hidden = false
		
		# Get coordinates and distance.
		object_origin = p.ship_state.aim_target.global_transform.origin
		object_name = p.ship_state.aim_target.get_name()
		# Player coords must be updated.
		player = p.camera_rig.global_transform.origin
		dist_val = round(player.distance_to(object_origin))
		
		# This is for UI.
		# Object visible, marker within range. Enable marker.

		
		# Multiply by scale factor of viewport to position properly.
		p.ui_paths.target.visible = not p.viewport.get_camera().is_position_behind(object_origin)
		p.ui_paths.target.rect_position = p.viewport.get_camera().unproject_position(
			object_origin)/p.common_viewport.render_res_factor
		
		# Update marker.
		var result_d = p.ui_paths.common_readouts.get_magnitude_units(dist_val)
		# Units. Also prevent crashing so there is a check.
		if result_d:
			p.ui_paths.target.get_node("Text_distance").text = \
				str(result_d[0])+ " " + result_d[1]
			# Object name in bb code.
			#p.ui_paths.target.get_node("Text_object").set_use_bbcode(true)
		p.ui_paths.target.get_node("Text_object").set_fit_content_height(true)
		p.ui_paths.target.get_node("Text_object").text = object_name
				
	elif not p.ship_state.aim_target_locked and not target_controls_hidden:
		p.ui_paths.target.hide()
		p.ui_paths.desktop_button_target_clear.hide()
		p.ui_paths.desktop_button_autopilot_start.hide()
		p.ui_paths.touchscreen_button_target_clear.hide()
		p.ui_paths.touchscreen_button_autopilot_start.hide()
		target_controls_hidden = true

func is_target_clear():
	# Clear target.
	p.ship_state.aim_target = Position3D
	p.ship_state.aim_target_locked = false
