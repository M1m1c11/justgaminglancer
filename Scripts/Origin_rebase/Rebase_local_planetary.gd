extends Position3D

onready var p = get_tree().get_root().get_node("Main/Paths")

var scenes = Position3D

func _ready():
	# ============================= Connect signals ===========================
	p.signals.connect("sig_exited_local_space_planetary", self, "is_exited_local_space_planetary")
	p.signals.connect("sig_entered_local_space_planetary", self, "is_entered_local_space_planetary")
	# =========================================================================

# SIGNAL PROCESSING
func is_entered_local_space_planetary(zone):
	
	# Get a child scenes.
	print("Entered zone: ", zone)
	scenes = zone.get_node("Scenes")
	
	# Recenter local space origin onto zone for best precision.
	p.local_space_planetary.global_transform = zone.global_transform

	# Reparent scenes from global to local space.
	zone.remove_child(scenes)
	p.local_space_planetary.add_child(scenes)

func is_exited_local_space_planetary(zone):
	
	print("Exited zone: ", zone)
	
	# Reparent scenes from local to global space (back to zone).
	p.local_space_planetary.remove_child(scenes)
	zone.add_child(scenes)
	scenes.global_transform = zone.global_transform
