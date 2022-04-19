extends Node

# CONSTANTS
const camera_far = 1e20 # Engine hard cap.
const camera_near = 0.01 # Engine hard cap.
const camera_fov = 60 # Initial value.
const camera_inertia_factor = 1.1 # 1.05 ... 1.5 Affects camera inertia.
const camera_sensitivity = 3
const camera_turret_roll_vert_limit = 70 # Deg +\-
# Zoom out times is multiplied by minimum ship camera distance to define maximum.
# Sync with touchscreen control slider (max_val = camera_zoom_out_times/camera_zoom_step).
const camera_zoom_out_times = 50
const camera_zoom_step = 0.1 # 0.05 ... 0.2

# VARIABLES
onready var p = get_tree().get_root().get_node("Main/Paths")

func _ready():
	# Set camera properties.
	p.camera.fov = camera_fov
	p.camera.far = camera_far
	p.camera.near = camera_near
