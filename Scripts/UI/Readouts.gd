extends Node


# READOUTS
func get_magnitude_units(val):
	# Val MUST BE IN DECIUNITS!
	# TODO: scale everything back to how it was and switch to units?
	if val < 1:
		return [round(val), "du"]
	elif (val >= 1) and (val < 1e3):
		return [round(val), "u"]
	elif (val >= 1e3) and (val < 1e6):
		return [round(val/1e3), "ku"]
	elif (val >= 1e6) and (val < 1e9):
		return [round(val/1e6), "Mu"]
	elif (val >= 1e9):
		return [round(val/1e9), "Gu"]
