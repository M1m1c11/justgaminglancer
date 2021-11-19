extends Node

# Nodes.
var camera = Node
var camera_rig = Node
var cam_opts = Node
var engine_opts = Node
var global_space = Node
var input = Node
var local_space = Node
var signals = Node
var ship_state = Node
var ship = Node
var ui = Node
var viewport = Node

func _ready():
	# ============================ Initialize nodes ===========================
	camera = get_node("/root/Container/View/Global_space/Ship/Camera_rig/Camera")
	camera_rig = get_node("/root/Container/View/Global_space/Ship/Camera_rig")
	cam_opts = get_node("/root/Container/Options/Camera")
	engine_opts = get_node("/root/Container/Options/Engine")
	global_space = get_node("/root/Container/View/Global_space")
	input = get_node("/root/Container/Input")
	local_space = get_node("/root/Container/View/Global_space/Local_space")
	signals = get_node("/root/Container/Signals")
	ship_state = get_node("/root/Container/Ship_state")
	ship = get_node("/root/Container/View/Global_space/Ship")
	ui = get_node("/root/Container/UI")
	viewport = get_node("/root/Container/View")



