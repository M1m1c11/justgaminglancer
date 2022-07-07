extends Position3D

var marker_script = load("res://Scripts/Marker.gd")
var star_sprite = load("res://Scenes/Sprites/Star_sprite.tscn")
var star_blue = load("res://Scenes/Environment/Stellar/Stars/Star_blue.tscn")

onready var p = get_tree().get_root().get_node("Main/Paths")
var system_zone = Area

func _ready():
	# ============================= Connect signals ===========================
	p.signals.connect("sig_system_coordinates_selected", self, "is_system_coordinates_selected")
	# =========================================================================

func is_system_coordinates_selected():
	# Get previously stored coordinates.
	system_zone = p.common_space_state.system_coordinates.duplicate()
	print(system_zone)
	self.add_child(system_zone)
	print(self.get_children())
	
	# Must be here in order to be spawned each time a coordinate is picked.
	# Later replace with instancing.
	var marker = Position3D.new()
	
	
	# TODO: make despawn queue with active system limit.
	# TODO: make proper despawning triggers.
	# TODO: make local markers (that work within stellar system).
	
	# Instance a stellar system scene.
	marker.set_script(marker_script)
	marker.add_child(star_sprite.instance())
	marker.add_child(star_blue.instance())
	marker.autopilot_range = 5e10
	
	system_zone.get_node("Scenes").add_child(marker)
	
	#print(system_zone.get_node("Scenes").get_children())
	
	# Emit a signal that everything has been done.
	p.signals.emit_signal("sig_system_spawned", marker)
