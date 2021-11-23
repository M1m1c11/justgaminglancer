extends Camera

var distance_factor = 15 # How far beyond culling it will be seen.

var sprite_scale = 0.0
var sprite_appearance_distance = 0.0


# Nodes.
var p = Node
var star = Node
var sprite_rig = Node
var sprite = Node


func _ready():
	# ============================ Initialize nodes ===========================
	p = get_node("/root/Container/Paths")
	star = p.local_space.get_node("System_Gate/Star_blue")
	sprite_rig = get_node("../Sprite_rig")
	sprite = get_node("../Sprite_rig/Sprite")

	
	# Distance at which sprite appears at full scale and visibility.
	sprite_appearance_distance = 0.5* p.cam_opts.camera_far
	sprite.translation.z = -sprite_appearance_distance
	
	sprite.scale *= sprite_appearance_distance*0.4
	# Record this value as ref
	sprite_scale = sprite.scale
	sprite.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var dist = self.global_transform.origin.distance_to(star.global_transform.origin)
	# Simply a normalized value.
	var dist_norm_orig = clamp(dist/( p.cam_opts.camera_far), 0.0, 1.0) # 0...1
	# Takes into account the distance factor. Keeps sprite visible at 0.1 scale after.
	var dist_norm = clamp(dist/( p.cam_opts.camera_far*distance_factor), 0.0, 0.93) # 0...0.9x
	var scale_norm = (cos(PI*dist_norm)+1)/2 # 0...1 depending on distance normalized
	sprite.scale = sprite_scale*scale_norm
	sprite_rig.look_at(star.global_transform.origin, Vector3(0.0, 0.0, 1.0))
	if dist <= sprite_appearance_distance:
		# Increase albedo from 0 to 1 at the half cull distance.
		var albedo = dist_norm_orig*2
		# Get and modify sprite intensity.
		var material = sprite.get_surface_material(0)
		material["shader_param/albedo"].r = albedo*1.2
		material["shader_param/albedo"].g = albedo*1.1
		material["shader_param/albedo"].b = albedo*1.2

