extends Position3D

export var galaxy_size = Vector3(1440000004889509888, 287999994105954304, 1440000004889509888)
# TODO: make a separate tool for this instead.
var system_trigger_script = load("res://Scripts/Local_space_triggers/Local_space_system.gd")
var system_trigger = load("res://Scenes/Zones/Local_space_triggers/Local_space_system.tscn")
var marker_script = load("res://Scripts/Marker.gd")
var star_sprite = load("res://Scenes/Sprites/Star_sprite.tscn")

var generated_systems_file_node_1 = load("res://Data/SCN/Stars_10k_gauss_distribution_1.scn")
var generated_systems_file_node_2 = load("res://Data/SCN/Stars_10k_gauss_distribution_2.scn")
var generated_systems_file_node_3 = load("res://Data/SCN/Stars_10k_gauss_distribution_3.scn")
var generated_systems_file_node_4 = load("res://Data/SCN/Stars_10k_gauss_distribution_4.scn")
var generated_systems_file_node_5 = load("res://Data/SCN/Stars_10k_gauss_distribution_5.scn")

var file = File.new()
var data = {}
	
# TODO: tie this to zone size.
var distance_increment = 1e2
var distance_increment_min = 1
var system_number = 10

var generated_systems = {}
var regex = RegEx.new()
var regex_space = RegEx.new()
var scene = PackedScene.new()
var ID = 0

func _ready():
	# Check if we are using the right nodes.
	var parent_galaxy = get_parent().get_parent()
	var parent_scenes_node = parent_galaxy.get_node("Scenes")
	# Stress testing RAM. These are 50k star system coordinates.
	var space_instance_1 = generated_systems_file_node_1.instance()
	var space_instance_2 = generated_systems_file_node_2.instance()
	var space_instance_3 = generated_systems_file_node_3.instance()
	var space_instance_4 = generated_systems_file_node_4.instance()
	var space_instance_5 = generated_systems_file_node_5.instance()
	print(space_instance_1.get_child(9999))
	print(space_instance_2.get_child(9999))
	print(space_instance_3.get_child(9999))
	print(space_instance_4.get_child(9999))
	print(space_instance_5.get_child(9999))
	
	# Align basis with the galaxy parent object.
	#self.global_transform.basis = get_parent().get_parent().global_transform.basis
	
		# Adding three different generators for the sake of consistency of distributions each way.
	#var rng_x = RandomNumberGenerator.new()
	#rng_x.seed = hash("x")
	
	#var rng_y = RandomNumberGenerator.new()
	#rng_y.seed = hash("y")
	
	#var rng_z = RandomNumberGenerator.new()
	#rng_z.seed = hash("z")
	
	#var mean = 0.0
	#var deviation = 2.0

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
		#var marker = Position3D.new()
		#marker.set_script(marker_script)
		#marker.add_child(star_sprite.instance())
		
		#system_trigger_instance.get_node("Scenes").add_child(marker)
		# Add coordinates (local transform) via distribution.
		#system_trigger_instance.transform.origin.x = (rng_x.randfn(mean, deviation)*0.2)*galaxy_size.x
		#system_trigger_instance.transform.origin.y = (rng_y.randfn(mean, deviation)*0.2)*galaxy_size.y
		#system_trigger_instance.transform.origin.z = (rng_z.randfn(mean, deviation)*0.2)*galaxy_size.z

		#self.add_child(system_trigger_instance)
		#system_trigger_instance.set_owner(self)
	
		#scene.pack(self)
		#ResourceSaver.save(generated_systems_file_node, scene)  # Or "user://..."
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
