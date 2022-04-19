extends Node

# VARIABLES
onready var p = get_tree().get_root().get_node("Main/Paths")
onready var ui_controls_bar = p.ui.get_node("Controls/Control_bar")
onready var ui_button_turret = p.ui.get_node("Controls/Control_bar/Button_turret")
onready var ui_gameplay = p.ui.get_node("Gameplay")

func _ready():
	# ============================ Connect signals ============================
	p.signals.connect("sig_turret_mode_on", self, "is_turret_mode_on")
	# =========================================================================

func handle_input(event):

	# Works in both desktop and touchscreen.
	if event is InputEventKey:
		
		# GUI CONTROLS (GENERIC) ==============================================
		
		# Mouse flight.
		if event.pressed and event.scancode == KEY_SPACE:
			if p.ship_state.mouse_flight:
				p.ship_state.mouse_flight = false
				p.signals.emit_signal("sig_mouse_flight_on", false)
			else:
				p.ship_state.mouse_flight = true
				p.signals.emit_signal("sig_mouse_flight_on", true)
		
		# Show toolbar.
		if event.pressed and event.scancode == KEY_BACKSPACE:
			if ui_controls_bar.visible:
				ui_controls_bar.visible = false
			else:
				ui_controls_bar.visible = true
				
			if ui_gameplay.visible:
				ui_gameplay.visible = false
			else:
				ui_gameplay.visible = true
				
		# Turret mode.
		if event.pressed and event.scancode == KEY_H:
			if not p.ship_state.turret_mode: 
				ui_button_turret.pressed = true
			else: ui_button_turret.pressed = false
		
		# Quit the game.
		# TODO: remove keyboard mapping later on.
		if event.pressed and event.scancode == KEY_ESCAPE:
			p.signals.emit_signal("sig_quit_game")
		
		# SHIP CONTROLS =======================================================
		
		# Accelerate forward.
		if event.pressed and event.scancode == KEY_UP:
			p.signals.emit_signal("sig_accelerate", true)

		# Accelerate backward.
		if event.pressed and event.scancode == KEY_DOWN:
			p.signals.emit_signal("sig_accelerate", false)
		
		# TODO: sort out acceleration WSAD keys
		# Accelerate up strafe (should be?)
		if event.pressed and event.scancode == KEY_W:
			p.signals.emit_signal("sig_accelerate", true)

		# Accelerate down strafe (should be?)
		if event.pressed and event.scancode == KEY_S:
			p.signals.emit_signal("sig_accelerate", false)
		
		# Engine kill.
		if event.pressed and event.scancode == KEY_Z:
			p.signals.emit_signal("sig_engine_kill")



# SIGNAL PROCESSING
func is_turret_mode_on(flag):
	p.ship_state.turret_mode = flag
