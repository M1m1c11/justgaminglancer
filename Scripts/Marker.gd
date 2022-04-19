extends Position3D

onready var p = get_tree().get_root().get_node("Main/Paths")
onready var marker = preload("res://Scenes/UI/Marker.tscn").instance()
export var object_name = "Marker name"

func _ready():	
	# Instance marker in the gameplay UI.
	p.ui_markers.add_child(marker)
	


func _physics_process(_delta):
	var player = p.camera_rig.global_transform.origin
	var object = self.global_transform.origin
	var dist_val = round(player.distance_to(object))
	
		# Origin. Multiply by scale factor of viewport.
	marker.visible = not p.viewport.get_camera().is_position_behind(object)
	marker.rect_position = p.viewport.get_camera().unproject_position(
		object)/p.viewport_opts.render_res_factor
	

	var result_d = p.ui_readouts.get_magnitude_units(dist_val)
	marker.get_node("Text").text = object_name + ": "\
			+str(result_d[0])+ " " + result_d[1]
