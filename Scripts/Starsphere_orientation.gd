extends Position3D

# Nodes.
var main = Node
var camera = Node

func _ready():
	# ============================ Initialize nodes ===========================
	main = get_node("/root/Cont/View/Main")
	camera = get_node("/root/Cont/View/Main/Ship/Camera_rig/Camera")


func _process(_delta):
	# Translation follows camera.
	self.global_transform.origin = camera.global_transform.origin
