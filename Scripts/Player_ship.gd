extends Position3D

# Nodes.
var engines = Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# ====================== Connect signals ==================================
	var input = get_node("/root/Main/Input")
	input.connect("engine_switched_on", self, "engines_on")
	input.connect("engine_switched_off", self, "engines_off")
	# =========================================================================
	
	# Initialize nodes instances.
	engines = get_node("Rogue_fighter/Engines")
	
	# Initialize the vessel params.
	init_ship()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init_ship():
	engines_off()

func engines_on():
	engines.show()
	
func engines_off():
	engines.hide()
