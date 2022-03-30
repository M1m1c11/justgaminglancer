extends MeshInstance

# Nodes.
onready var p = get_tree().get_root().get_node("Container/Paths")


func _process(_delta):
	# Translation follows camera.
	self.global_transform.origin = p.camera.global_transform.origin
