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
	is_screen_filter_on(p.common_viewport.render_texture_filter)

func init_viewport_update():
	# Has to be called manually bc doesn't initiate at start.
	print("updated")
	var common_viewport = get_node("/root/Main/Common/Viewport")
	self.size = Vector2(1024, 600) * common_viewport.render_res_factor
	#print("viewport updtated"); print(common_viewport.render_res_factor)
	#print(self.size)

# SIGNAL PROCESSING
func is_screen_filter_on(flag):
	if flag:
		p.common_viewport.render_texture_filter = true
		self.get_texture().flags = Texture.FLAG_FILTER
	else:
		p.common_viewport.render_texture_filter = false
		self.get_texture().flags = !Texture.FLAG_FILTER
		
func is_viewport_update():
	# Has to be called manually bc doesn't initiate at start.
	var common_viewport = get_node("/root/Main/Common/Viewport")
	self.size = OS.window_size * common_viewport.render_res_factor
	#print("viewport updtated"); print(common_viewport.render_res_factor)
	#print(self.size)
	
func is_render_res_value_changed(value):
	p.common_viewport.render_res_factor = value
	is_viewport_update()
