extends Node

# Rename all signals to "sig_<name_action>".
# Emitting functions should be "<name>_is_<action>".
# Receiving functions should be "is_<name_action>".
# Respective state vars should be "state_<name>"

# Have to supress warning because they all flare up.
# warning-ignore-all:unused_signal

# GENERIC
signal sig_mouse_on_control_area(flag)
signal sig_screen_filter_on(flag)
signal sig_screen_res_value_changed(value)
signal sig_fov_value_changed(value)
signal sig_viewport_update
signal sig_quit_game

# CAMERA
signal sig_turret_mode_on(flag)
signal sig_mouse_flight_on(flag)
signal sig_zoom_value_changed(value)

# SHIP
signal sig_accelerate(flag)
signal sig_engine_kill

