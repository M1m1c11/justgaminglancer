extends Node

# TODO: PREFIXES TO PATHS BY CATEGORY!

# CAMERA
onready var camera = get_node("/root/Container/View/Ship/Camera_rig/Camera")
onready var camera_rig = get_node("/root/Container/View/Ship/Camera_rig")

# OPTIONS
onready var cam_opts = get_node("/root/Container/Options/Camera")
onready var engine_opts = get_node("/root/Container/Options/Engine")
onready var viewport_opts = get_node("/root/Container/Options/Viewport")

# INPUT
onready var input = get_node("/root/Container/Input")
onready var input_keyboard = get_node("/root/Container/Input/Keyboard")
onready var input_mouse = get_node("/root/Container/Input/Mouse")
onready var input_pad = get_node("/root/Container/Input/Pad")

# SIGNALS
onready var signals = get_node("/root/Container/Signals")

#STATES
onready var ship_state = get_node("/root/Container/Ship_state")

# UI
onready var ui = get_node("/root/Container/UI")
onready var ui_debug = get_node("/root/Container/UI/Debug")
onready var ui_markers = get_node("/root/Container/UI/Markers")
onready var ui_readouts = get_node("/root/Container/UI/Readouts")
onready var ui_desktop_buttons = get_node("/root/Container/UI/Desktop_buttons")
onready var ui_mobile_buttons = get_node("/root/Container/UI/Mobile_buttons")
onready var ui_pad = get_node("/root/Container/UI/Mobile_buttons/Pad")
onready var ui_windows = get_node("/root/Container/UI/Windows")

# VIEWPORT
onready var viewport = get_node("/root/Container/View")

# MISC
onready var ship = get_node("/root/Container/View/Ship")
onready var global_space = get_node("/root/Container/View/Global_space")
onready var local_space2 = get_node("/root/Container/View/Global_space/Local_space2")
onready var cube = get_node("/root/Container/View/Global_space/Planet_local/Cube")
