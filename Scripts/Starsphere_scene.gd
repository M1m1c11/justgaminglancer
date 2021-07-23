extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var tmp_scale = self.scale;
	self.global_transform.basis = get_node("/root/Main").global_transform.basis;
	#self.scale = tmp_scale;
