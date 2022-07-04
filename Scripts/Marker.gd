extends Position3D

export var autopilot_range = 1e5
export var visible_on_starmap = true

onready var p = get_tree().get_root().get_node("Main/Paths")

func _ready():

	# Insert marker into the global marker list (and keep it there)
	p.common_space_state.markers.append(self)
