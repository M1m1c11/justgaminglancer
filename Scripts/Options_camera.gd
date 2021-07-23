extends Node

# TODO: make a function to cap values and pass those through it.
export var camera_chase_offset = 1 		# Is added to bounding box axis value.
export var camera_chase_vert_offset = 2 		# TODO: unique for each ship?
export var camera_chase_tilt_horiz_limit = 0 	# Deg +\-
export var camera_chase_tilt_vert_limit = 0 	# Deg +\-
export var camera_inertia_factor = 1.1	# 1.05 ... 1.5 Affects camera inertia.
export var camera_sensitivity = 3 	# 0.1 ... 0.5
export var camera_turret_roll_vert_limit = 70 	# Deg +\-
export var camera_zoom_out_times = 3 	# Times ship's bounding box axis length.
export var camera_zoom_step = 0.1 		# 0.05 ... 0.2
