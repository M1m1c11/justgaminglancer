extends Node

# TODO: make a function to cap values and pass those through it.
var camera_far = 1e9 # 1000000 is a hard cap.
var camera_near = 0.01 # 0.01 is a hard cap.

# TODO: make FOV constant and a function of velocity.
var camera_fov = 60 # Is added to bounding box axis value. (????)
var camera_inertia_factor = 1.1 # 1.05 ... 1.5 Affects camera inertia.
var camera_sensitivity = 3 # 0.1 ... 0.5
var camera_turret_roll_vert_limit = 70 # Deg +\-
# Zoom out times is multiplied by minimum ship camera distance to define maximum.
# Sync with touchscreen control slider (max_val = camera_zoom_out_times/camera_zoom_step).
var camera_zoom_out_times = 50
var camera_zoom_step = 0.1 # 0.05 ... 0.2
var velocity_factor_on_tilt = 0.1 # Should be more than one

# Paths node.
onready var p = get_tree().get_root().get_node("Container/Paths")

func _ready():
	# ============================ Initialize nodes ===========================

	# ============================ Connect signals ============================
	p.signals.connect("sig_fov_value_changed", self, "is_fov_value_changed")
	# =========================================================================
	
	# Set camera properties.
	p.camera.fov = camera_fov
	p.camera.far = camera_far
	p.camera.near = camera_near

func is_fov_value_changed(value):
	p.camera.fov = value
