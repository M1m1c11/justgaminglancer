extends Node

export var physics_fps = 60
export var graphic_fps = 60
export var ship_linear_damp = 1
export var ship_angular_damp = 5

func _ready():
	Engine.set_iterations_per_second(physics_fps)
	Engine.set_target_fps(graphic_fps)
