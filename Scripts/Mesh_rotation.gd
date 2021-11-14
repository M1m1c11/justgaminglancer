extends MeshInstance


export var rotation_speed_x = 0.0
export var rotation_speed_y = 0.0
export var rotation_speed_z = 0.0

# Nodes.
var engine_opts = Node

func _ready():
	# ============================ Initialize nodes ===========================
	engine_opts = get_node("/root/Cont/View/Main/Options/Engine")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var rx = rotation_speed_x*delta
	var ry = rotation_speed_y*delta
	var rz = rotation_speed_z*delta

	self.rotate_x(rx)
	self.rotate_y(ry)
	self.rotate_z(rz)
