extends Node

# TODO: PREFIXES TO PATHS BY CATEGORY?

# MAIN
onready var main = get_node("/root/Main")

# CAMERA
onready var camera = get_node("/root/Main/Container/View/Ship/Camera_rig/Camera")
onready var camera_rig = get_node("/root/Main/Container/View/Ship/Camera_rig")

# OPTIONS
onready var cam_opts = get_node("/root/Main/Options/Camera")
onready var engine_opts = get_node("/root/Main/Options/Engine")
onready var viewport_opts = get_node("/root/Main/Options/Viewport")

# INPUT
onready var input = get_node("/root/Main/Input")
onready var input_keyboard = get_node("/root/Main/Input/Keyboard")
onready var input_mouse = get_node("/root/Main/Input/Mouse")
onready var input_pad = get_node("/root/Main/Input/Pad")

# SIGNALS
onready var signals = get_node("/root/Main/Signals")

#STATES
onready var ship_state = get_node("/root/Main/Ship_state")

# UI
onready var ui = get_node("/root/Main/Container/UI")
onready var ui_debug = get_node("/root/Main/Container/UI/Debug")
onready var ui_readouts = get_node("/root/Main/Container/UI/Readouts")
onready var ui_desktop_buttons = get_node("/root/Main/Container/UI/Desktop_buttons")
onready var ui_gameplay = get_node("/root/Main/Container/UI/Gameplay")
onready var ui_markers = get_node("/root/Main/Container/UI/Gameplay/Markers")
onready var ui_mobile_buttons = get_node("/root/Main/Container/UI/Mobile_buttons")
onready var ui_pad = get_node("/root/Main/Container/UI/Mobile_buttons/Pad")
onready var ui_windows = get_node("/root/Main/Container/UI/Windows")

# VIEWPORT
onready var viewport = get_node("/root/Main/Container/View")

# MISC
onready var ship = get_node("/root/Main/Container/View/Ship")
onready var global_space = get_node("/root/Main/Container/View/Global_space")
onready var local_spaces = get_node("/root/Main/Container/View/Local_spaces")
