extends Viewport

export var scale_factor = 0.65

func _ready():
	self.get_texture().flags = Texture.FLAG_FILTER
	self.size = Vector2(1024, 600)*scale_factor

# TODO: implement ratio setting, factor, size

func _on_View_size_changed():
	self.size = Vector2(1024, 600)*scale_factor
