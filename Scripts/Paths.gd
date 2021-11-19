extends Node

# Nodes.
var camera = Node
var cam_opts = Node
var input = Node
var signals = Node
var ship_state = Node
var ship = Node
var ui = Node

func _ready():
	# ============================ Initialize nodes ===========================
	camera = get_node("/root/Cont/View/Main/Ship/Camera_rig/Camera")
	cam_opts = get_node("/root/Cont/View/Main/Options/Camera")
	input = get_node("/root/Cont/View/Main/Input")
	signals = get_node("/root/Cont/View/Main/Input/Signals")
	ship_state = get_node("/root/Cont/View/Main/Ship/Ship_state")
	ship = get_node("/root/Cont/View/Main/Ship")
	ui = get_node("/root/Cont/UI")
