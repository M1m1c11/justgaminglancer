extends Viewport

# VARIABLES
onready var p = get_tree().get_root().get_node("Container/Paths")

func _ready():
	# ============================ Connect signals ============================
	p.signals.connect("sig_screen_filter_on", self, "is_screen_filter_on")
	p.signals.connect("sig_viewport_update", self, "is_viewport_update")
	p.signals.connect("sig_screen_res_value_changed", self, "is_screen_res_value_changed")
	# =========================================================================
	
	# Init 
	# TODO: sync UI elements.
	is_viewport_update()
	is_screen_filter_on(p.viewport_opts.render_texture_filter)
	
# SIGNAL PROCESSING
func is_screen_filter_on(flag):
	if flag:
		p.viewport_opts.render_texture_filter = true
		self.get_texture().flags = Texture.FLAG_FILTER
	else:
		p.viewport_opts.render_texture_filter = false
		self.get_texture().flags = !Texture.FLAG_FILTER
		
func is_viewport_update():
	self.size = OS.window_size * p.viewport_opts.screen_res_factor

func is_screen_res_value_changed(value):
	p.viewport_opts.screen_res_factor = value
	is_viewport_update()
