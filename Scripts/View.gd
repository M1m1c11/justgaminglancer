extends Viewport

# VARIABLES
onready var p = get_tree().get_root().get_node("Main/Paths")

func _ready():
	# ============================ Connect signals ============================
	p.signals.connect("sig_screen_filter_on", self, "is_screen_filter_on")
	p.signals.connect("sig_viewport_update", self, "is_viewport_update")
	p.signals.connect("sig_render_res_value_changed", self, "is_render_res_value_changed")
	# =========================================================================
	
	# Init 
	# TODO: sync UI elements.
	init_viewport_update()
	is_screen_filter_on(p.viewport_opts.render_texture_filter)

func init_viewport_update():
	# Has to be called manually bc doesn't initiate at start.
	print("updated")
	var viewport_opts = get_node("/root/Main/Options/Viewport")
	self.size = Vector2(1024, 600) * viewport_opts.render_res_factor
	#print("viewport updtated"); print(viewport_opts.render_res_factor)
	#print(self.size)

# SIGNAL PROCESSING
func is_screen_filter_on(flag):
	if flag:
		p.viewport_opts.render_texture_filter = true
		self.get_texture().flags = Texture.FLAG_FILTER
	else:
		p.viewport_opts.render_texture_filter = false
		self.get_texture().flags = !Texture.FLAG_FILTER
		
func is_viewport_update():
	# Has to be called manually bc doesn't initiate at start.
	var viewport_opts = get_node("/root/Main/Options/Viewport")
	self.size = OS.window_size * viewport_opts.render_res_factor
	#print("viewport updtated"); print(viewport_opts.render_res_factor)
	#print(self.size)
	
func is_render_res_value_changed(value):
	p.viewport_opts.render_res_factor = value
	is_viewport_update()
