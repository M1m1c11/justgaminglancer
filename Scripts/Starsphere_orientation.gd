extends Position3D

# Nodes.
var p = Node

func _ready():
	# ============================ Initialize nodes ===========================
	p = get_node("/root/Container/Paths")


func _process(_delta):
	# Translation follows camera.
	self.global_transform.origin = p.camera.global_transform.origin
