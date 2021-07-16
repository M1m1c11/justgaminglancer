extends Node

# TODO: make a function to cap values and pass those through it.
export var camera_sensitivity = 0.3 # 0.1 ... 0.5
export var camera_vert_limit_deg = 70 # Deg +\-
export var camera_zoom_out_times = 3 # Times ship's bounding box axis length.
export var camera_zoom_step = 0.1 # 0.05 ... 0.2
export var camera_vert_offset = 1 	# TODO: unique for each ship?
export var camera_chase_offset = 1 	# Is added to bounding box axis value.
