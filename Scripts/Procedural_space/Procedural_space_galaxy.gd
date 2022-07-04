extends Position3D

export var galaxy_size = Vector3(1440000004889509888, 287999994105954304, 1440000004889509888)
# TODO: make a separate tool for this instead.
var system_trigger_script = load("res://Scripts/Local_space_triggers/Local_space_system.gd")
var system_trigger = load("res://Scenes/Zones/Local_space_triggers/Local_space_system.tscn")
var marker_script = load("res://Scripts/Marker.gd")
var star_sprite = load("res://Scenes/Sprites/Star_sprite.tscn")
var generated_systems_file = "res://Data/Galaxy.systemlist"
var generated_systems_file_pack = "res://Data/Galaxy.pck"
var file = File.new()
var data = {}
	
# TODO: tie this to zone size.
var distance_increment = 1e2
var distance_increment_min = 1
var system_number = 97323

var generated_systems = {}
var regex = RegEx.new()
var regex_space = RegEx.new()
var ID = 0

func _ready():
	# Check if we are using the right nodes.
	var parent_galaxy = get_parent().get_parent()
	var parent_scenes_node = parent_galaxy.get_node("Scenes")
	
	# Align basis with the galaxy parent object.
	self.global_transform.basis = get_parent().get_parent().global_transform.basis

	#print("trying to load file")
	
	#if file.file_exists(generated_systems_file):
	#	file.open(generated_systems_file, File.READ)
	#	data = file.get_var(true)
	#	print(data["systems_number"])
	#	print(data["systems_list"][0])
	#	file.close()
	#else: 
	#	print("No systems file")
	#	print("trying from pack")
	#	print(ProjectSettings.load_resource_pack(generated_systems_file_pack, true))
	
	
	# Create zones to spawn stellar systems in.
	#for system in system_number:
		# Instance a stellar system triggers.
		#var system_trigger_instance = system_trigger.instance()
		#system_trigger_instance.set_script(system_trigger_script)
		
		# Add coordinates (local transform) via distribution.
		#system_trigger_instance.transform.origin.x = (rng_x.randfn(mean, deviation)*0.2)*galaxy_size.x
		#system_trigger_instance.transform.origin.y = (rng_y.randfn(mean, deviation)*0.2)*galaxy_size.y
		#system_trigger_instance.transform.origin.z = (rng_z.randfn(mean, deviation)*0.2)*galaxy_size.z
	

	
		# Insert stellar system zones into global space. Or galaxy local
		#self.add_child(system_trigger_instance)
	
		#var marker = Position3D.new()
		#marker.add_child(star_sprite.instance())
		#marker.set_script(marker_script)
		#system_trigger_instance.get_node("Scenes").add_child(marker)
		# TODO: assign some name
		



		
	# Get each zone and put a marker into it.
	#for zone in self.get_children():
		
		# TODO: Replace it with a generic system scene.
	#	var marker = Position3D.new()
	#	marker.add_child(star_sprite.instance())
	#	marker.set_script(marker_script)
		
		# Make sure there are no odd nodes in the parent.
	#	if marker.is_class("Position3D"):
	#		zone.add_child(marker)
