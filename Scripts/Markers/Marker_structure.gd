extends Position3D
class_name MarkerStructure, "res://Assets/UI_images/SVG/icons/structure_marker.svg"

export var autopilot_range = 1e3
export var targetable = true

onready var p = get_tree().get_root().get_node("Main/Paths")

func _ready():

	# Insert marker into the global marker list (and keep it there)
	p.common_space_state.markers.append(self)
	
