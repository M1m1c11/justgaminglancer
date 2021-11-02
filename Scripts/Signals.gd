extends Node

# Rename all signals to "sig_<name_action>".
# Emitting functions should be "<name>_is_<action>".
# Receiving functions should be "is_<name_action>".
# Respective state vars should be "state_<name>"

# warning-ignore-all:unused_signal
# ============================== Generic =====================================
signal sig_mouse_on_viewport(flag)
signal sig_screen_filter_on(flag)
signal sig_screen_res_value_changed(value)
signal sig_fov_value_changed(value)
signal sig_viewport_update
signal sig_quit_game

# =============================== Camera =====================================
signal sig_turret_mode_on(flag)
signal sig_mouse_flight_on(flag)

# ================================ Ship =======================================
signal sig_accelerate(flag)
signal sig_engine_kill(flag)

