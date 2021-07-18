extends Position3D

# Nodes.
var engines = Node
var input = Node
var ui = Node
var signals = Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# ============================ Initialize nodes ===========================
	engines = get_node("Rogue_fighter/Engines")
	input = get_node("/root/Main/Input")
	ui = get_node("/root/Main/UI")
	signals = get_node("/root/Main/Input/Signals")
	# ============================= Connect signals ===========================
	signals.connect("sig_ship_engine", self, "is_ship_engine_on")
	# =========================================================================
	
	# Initialize the vessel params.
	init_ship()
	

#func _process(delta):
#	pass

# ================================== Other ====================================
func init_ship():
	engines.hide()

func is_ship_engine_on(flag):
	if flag: engines.show()
	else: engines.hide()
