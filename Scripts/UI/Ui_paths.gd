extends Node

# GLOBAL PATHS 
onready var p = get_tree().get_root().get_node("Main/Paths")
# Common
onready var common = p.ui.get_node("Common")
onready var common_mobile_buttons = common.get_node("Mobile_buttons")
onready var common_mobile_buttons_pad = common_mobile_buttons.get_node("Pad")
onready var common_desktop_buttons = common.get_node("Desktop_buttons")
onready var common_readouts = common.get_node("Readouts")
onready var common_debug = common.get_node("Debug")
# Desktop UI
onready var controls_desktop = p.ui.get_node("GUI_desktop")
onready var mouse_area = controls_desktop.get_node("Mouse_area")
onready var desktop_options = controls_desktop.get_node("Options")
onready var desktop_main = controls_desktop.get_node("Main")
# Desktop nav popup
onready var desktop_nav_popup = desktop_main.get_node("Popup_nav")
onready var desktop_nav_list = desktop_nav_popup.get_node("ItemList_nav")
# Desktop buttons
onready var desktop_button_target_clear = desktop_main.get_node("Button_target_clear")
onready var desktop_button_autopilot_disable = desktop_main.get_node("Button_autopilot_disable")
onready var desktop_button_autopilot_start = desktop_nav_popup.get_node("Button_autopilot_start")

# Touchscreen UI
onready var controls_touchscreen = p.ui.get_node("GUI_touchscreen")
onready var touchscreen_options = controls_touchscreen.get_node("Options")
onready var touchscreen_main = controls_touchscreen.get_node("Main")
onready var touchscreen_pad_base = touchscreen_main.get_node("Pad_base")
onready var touchscreen_stick = touchscreen_pad_base.get_node("Stick")
# Touchscreen nav popup
onready var touchscreen_nav_popup = touchscreen_main.get_node("Popup_nav_touchscreen")
onready var touchscreen_nav_list = touchscreen_nav_popup.get_node("ItemList_nav_touchscreen")
# Touchscreen buttons
onready var touchscreen_button_target_clear = touchscreen_main.get_node("Button_target_clear_touchscreen")
onready var touchscreen_button_autopilot_disable = touchscreen_main.get_node("Button_autopilot_disable_touchscreen")
onready var touchscreen_button_autopilot_start = touchscreen_nav_popup.get_node("Button_autopilot_start_touchscreen")
# Gameplay UI
onready var gameplay = p.ui.get_node("Gameplay")
onready var debug = gameplay.get_node("Debug")
onready var target = gameplay.get_node("Target")
onready var text_panel = gameplay.get_node("Text_panel")
# Other windows
onready var gui_prompt = p.ui.get_node("GUI_prompt_greeting")



func init_gui():
	# Initialize windows in switched off mode to match button states.
	gui_prompt.hide()
	gui_prompt.show()
	
	controls_desktop.hide()
	controls_touchscreen.hide()
	touchscreen_options.hide()
	mouse_area.hide() # TODO: Maybe not the best approach?
	gameplay.hide()
	debug.hide()
	text_panel.hide()
	desktop_nav_popup.hide()
