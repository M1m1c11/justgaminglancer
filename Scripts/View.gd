extends Viewport

# Values.
# TODO: Throw it into options and sync with slider
var screen_res_factor = 0.7 
# Objects.
# Parameters.
# Nodes.
var signals = Node

func _ready():
	# ======================Z====== Initialize nodes ===========================
	signals = get_node("/root/Cont/View/Main/Input/Signals")
	# ============================ Connect signals ============================
	signals.connect("sig_screen_filter_on", self, "is_screen_filter_on")
	signals.connect("sig_viewport_update", self, "is_viewport_update")
	signals.connect("sig_screen_res_value_changed", self, "is_screen_res_value_changed")
	# =========================================================================
	
	
# ============================ Signal processing ==============================	
func is_screen_filter_on(flag):
	if flag: 
		self.get_texture().flags = Texture.FLAG_FILTER
		print("ON")
	else: 
		self.get_texture().flags = !Texture.FLAG_FILTER
		print("OFF")
		
func is_viewport_update():
	self.size = OS.window_size*screen_res_factor

func is_screen_res_value_changed(value):
	screen_res_factor = value
	self.size = OS.window_size*screen_res_factor
