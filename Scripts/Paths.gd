extends Node

# Nodes.
onready var camera = get_node("/root/Container/View/Ship/Camera_rig/Camera")
onready var camera_rig = get_node("/root/Container/View/Ship/Camera_rig")
onready var cam_opts = get_node("/root/Container/Options/Camera")
onready var engine_opts = get_node("/root/Container/Options/Engine")
onready var global_space = get_node("/root/Container/View/Global_space")
onready var input = get_node("/root/Container/Input")
onready var local_space = get_node("/root/Container/View/Global_space/Local_space")
onready var local_space2 = get_node("/root/Container/View/Global_space/Local_space2")
onready var signals = get_node("/root/Container/Signals")
onready var ship_state = get_node("/root/Container/Ship_state")
onready var ship = get_node("/root/Container/View/Ship")
onready var ui = get_node("/root/Container/UI")
onready var viewport = get_node("/root/Container/View")
