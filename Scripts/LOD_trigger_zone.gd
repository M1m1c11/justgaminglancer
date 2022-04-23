extends Spatial

onready var p = get_tree().get_root().get_node("Main/Paths")

var in_lod0_zone = false
var in_lod1_zone = false
var in_lod2_zone = false

func _ready():
	# Do this to prevent "LOD" nodes being accidentally hidden.
	for child in self.get_children():
		if child.has_method("set_visible"):
			child.show()


func adjust_lods():
	# Entered outermost zone, not entered further yet, enable LOD2.
	if in_lod2_zone and !in_lod1_zone and !in_lod0_zone:
		show_scenes("LOD2")
		
		hide_scenes("LOD1")
		hide_scenes("LOD0")
	# Entered second zone, not entered zone 0 yet, enable LOD1.
	elif in_lod2_zone and in_lod1_zone and !in_lod0_zone:
		show_scenes("LOD1")
		
		hide_scenes("LOD2")
		hide_scenes("LOD0")
	# Entered innermost zone, enable LOD0.
	elif in_lod2_zone and in_lod1_zone and in_lod0_zone:
		show_scenes("LOD0")
		
		hide_scenes("LOD1")
		hide_scenes("LOD2")
	# Otherwise hide all scenes.
	else:
		hide_scenes("LOD0")
		hide_scenes("LOD1")
		hide_scenes("LOD2")

func show_scenes(lod_name):
	self.get_node(lod_name).get_node("Scene_items").show()
			
func hide_scenes(lod_name):
	self.get_node(lod_name).get_node("Scene_items").hide()


# SIGNAL PROCESSING.
# Entering zones.
func _on_LOD0_body_entered(_body):
	if _body == p.ship: in_lod0_zone = true
	adjust_lods()


func _on_LOD1_body_entered(_body):
	if _body == p.ship: in_lod1_zone = true
	adjust_lods()

func _on_LOD2_body_entered(_body):
	if _body == p.ship: in_lod2_zone = true
	adjust_lods()
	
# Exiting zones.
func _on_LOD0_body_exited(_body):
	if _body == p.ship: in_lod0_zone = false
	adjust_lods()

func _on_LOD1_body_exited(_body):
	if _body == p.ship: in_lod1_zone = false
	adjust_lods()

func _on_LOD2_body_exited(_body):
	if _body == p.ship: in_lod2_zone = false
	adjust_lods()
