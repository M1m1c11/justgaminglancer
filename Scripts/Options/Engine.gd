extends Node

# CONSTANTS
const physics_fps = 120
const graphic_fps = 60
const ship_linear_damp = 1
const ship_angular_damp = 5
const ship_linear_damp_ekill = 0.1 # Obsolete?

func _ready():
	Engine.set_iterations_per_second(physics_fps)
	Engine.set_target_fps(graphic_fps)
