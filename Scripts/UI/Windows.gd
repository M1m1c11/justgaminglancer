extends Node

# VARIABLES 
onready var p = get_tree().get_root().get_node("Main/Paths")
onready var controls = p.ui.get_node("Controls")
onready var controls_touchscreen = p.ui.get_node("Controls_touchscreen")
onready var debug = p.ui.get_node("Gameplay/Debug")
onready var gui_prompt = p.ui.get_node("GUI_prompt")
onready var gameplay = p.ui.get_node("Gameplay")
onready var mouse_area = p.ui.get_node("Controls/Mouse_area")
onready var text_panel = p.ui.get_node("Gameplay/Text_panel")
onready var touchscreen_options = p.ui.get_node("Controls_touchscreen/Options_menu")
onready var touchscreen_main = p.ui.get_node("Controls_touchscreen/Main_controls")

func init_gui():
	# Initialize windows in switched off mode to match button states.
	gui_prompt.hide()
	gui_prompt.show()
	
	controls.hide()
	controls_touchscreen.hide()
	touchscreen_options.hide()
	mouse_area.hide() # TODO: Maybe not the best approach?
	gameplay.hide()
	debug.hide()
	text_panel.hide()
