extends Node

# TODO: make a function to cap values and pass those through it.
export var camera_far = 500000 # 1000000 is a hard cap.
export var camera_near = 0.03 # 0.01 is a hard cap.
export var camera_fov = 60 # Is added to bounding box axis value.
export var camera_inertia_factor = 1.1 # 1.05 ... 1.5 Affects camera inertia.
export var camera_sensitivity = 3 # 0.1 ... 0.5
export var camera_turret_roll_vert_limit = 70 # Deg +\-
export var camera_zoom_out_times = 5 # Times ship's bounding box axis length.
export var camera_zoom_step = 0.1 # 0.05 ... 0.2
export var velocity_factor_on_tilt = 0.1 # Should be more than one

# Paths node.
var p = Node

func _ready():
	# ============================ Initialize nodes ===========================
	p = get_node("/root/Container/Paths")
	# ============================ Connect signals ============================
	p.signals.connect("sig_fov_value_changed", self, "is_fov_value_changed")
	# =========================================================================
	
	# Set camera properties.
	p.camera.fov = camera_fov
	p.camera.far = camera_far
	p.camera.near = camera_near

func is_fov_value_changed(value):
	p.camera.fov = value
