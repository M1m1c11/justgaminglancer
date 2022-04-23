extends Position3D

onready var p = get_tree().get_root().get_node("Main/Paths")

onready var rebase_limit = p.common_engine.rebase_limit_margin
var rebase_local = false

func _physics_process(_delta):
	# Hide ship from view to prevent annoying visuals jitter.
	# TODO: add a sprite for the value above which is projected.
	# TODO: 
	if rebase_limit > p.ship.camera_push_visibility_velocity:
		p.ship.hide()
	else:
		p.ship.show()


	if p.ship.translation.x > rebase_limit:
		p.ship.translation.x = 0
		p.global_space.translation.x = p.global_space.translation.x-rebase_limit
		if rebase_local: p.signals.emit_signal("rebase_x_plus")
		
	elif p.ship.translation.x < -rebase_limit:
		p.ship.translation.x = 0
		p.global_space.translation.x = p.global_space.translation.x+rebase_limit
		if rebase_local: p.signals.emit_signal("rebase_x_minus")
		
	if p.ship.translation.y > rebase_limit:
		p.ship.translation.y = 0
		p.global_space.translation.y = p.global_space.translation.y-rebase_limit
		if rebase_local: p.signals.emit_signal("rebase_y_plus")
		
	elif p.ship.translation.y < -rebase_limit:
		p.ship.translation.y = 0
		p.global_space.translation.y = p.global_space.translation.y+rebase_limit
		if rebase_local: p.signals.emit_signal("rebase_y_minus")
		
	if p.ship.translation.z > rebase_limit:
		p.ship.translation.z = 0
		p.global_space.translation.z = p.global_space.translation.z-rebase_limit
		if rebase_local: p.signals.emit_signal("rebase_z_plus")
		
	elif p.ship.translation.z < -rebase_limit:
		p.ship.translation.z = 0
		p.global_space.translation.z = p.global_space.translation.z+rebase_limit
		if rebase_local: p.signals.emit_signal("rebase_z_minus")
