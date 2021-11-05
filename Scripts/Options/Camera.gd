extends Node

# TODO: make a function to cap values and pass those through it.
export var camera_far = 100000 # 1000000 is a hard cap.
export var camera_near = 0.03 # 0.01 is a hard cap.
export var camera_fov = 40 # Is added to bounding box axis value.
export var camera_inertia_factor = 1.1 # 1.05 ... 1.5 Affects camera inertia.
export var camera_sensitivity = 3 # 0.1 ... 0.5
export var camera_turret_roll_vert_limit = 70 # Deg +\-
export var camera_zoom_out_times = 5 # Times ship's bounding box axis length.
export var camera_zoom_step = 0.1 # 0.05 ... 0.2
export var velocity_factor_on_tilt = 0.1 # Should be more than one

# Nodes.
var camera = Node
var signals = Node

func _ready():
	# ============================ Initialize nodes ===========================
	camera = get_node("/root/Cont/View/Main/Ship/Camera_rig/Camera")
	signals = get_node("/root/Cont/View/Main/Input/Signals")
	# ============================ Connect signals ============================
	signals.connect("sig_fov_value_changed", self, "is_fov_value_changed")
	# =========================================================================
	
	# Set camera properties.
	camera.fov = camera_fov
	camera.far = camera_far
	camera.near = camera_near

func is_fov_value_changed(value):
	camera.fov = value
