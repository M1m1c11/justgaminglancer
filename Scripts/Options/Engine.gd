extends Node

onready var physics_fps = 120
onready var graphic_fps = 60
onready var ship_linear_damp = 1
onready var ship_angular_damp = 5
onready var ship_linear_damp_ekill = 0.1

func _ready():
	Engine.set_iterations_per_second(physics_fps)
	Engine.set_target_fps(graphic_fps)
