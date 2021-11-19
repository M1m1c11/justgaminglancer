extends Viewport

# TODO: make a script in top most noce that will initiate all options and values
# on startup, to ensure that everything is ready at startup.

# Values.
# TODO: Throw it into options and sync with slider
var screen_res_factor = 0.7
# Objects.
# Parameters.
# Nodes.
var p = Node

func _ready():
	# ======================Z====== Initialize nodes ===========================
	p = get_node("/root/Container/Paths")
	# ============================ Connect signals ============================
	p.signals.connect("sig_screen_filter_on", self, "is_screen_filter_on")
	p.signals.connect("sig_viewport_update", self, "is_viewport_update")
	p.signals.connect("sig_screen_res_value_changed", self, "is_screen_res_value_changed")
	# =========================================================================
	
	# Init the screen res and factor
	self.size = OS.window_size*screen_res_factor
	self.get_texture().flags = Texture.FLAG_FILTER
	
# ============================ Signal processing ==============================	
func is_screen_filter_on(flag):
	if flag: self.get_texture().flags = Texture.FLAG_FILTER
	else: self.get_texture().flags = !Texture.FLAG_FILTER
		
func is_viewport_update():
	self.size = OS.window_size*screen_res_factor

func is_screen_res_value_changed(value):
	screen_res_factor = value
	self.size = OS.window_size*screen_res_factor
