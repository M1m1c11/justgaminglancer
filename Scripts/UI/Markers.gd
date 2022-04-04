extends Node

onready var p = get_tree().get_root().get_node("Container/Paths")
onready var marker = p.ui.get_node("Main3D/Debug/Marker")
onready var marker2 = p.ui.get_node("Main3D/Debug/Marker2")
onready var marker3 = p.ui.get_node("Main3D/Debug/Marker3")

func update_markers():
	# MARKER
	# TODO: make a system of spatial markers. Proper ones.
	# This should be an iterator over objects within proximity.
	var loc = p.camera_rig.global_transform.origin
	var loc_cube = p.cube.global_transform.origin
	#var loc2 = monolith.global_transform.origin
	
	# Origin. Multiply by scale factor of viewport.
	marker.visible = not p.viewport.get_camera().is_position_behind(loc_cube)
	marker.rect_position = p.viewport.get_camera().unproject_position(
		loc_cube)/p.viewport_opts.screen_res_factor
	# TODO: properly align and center on the object.
	# Adjust displayed distance
	
	
	# TODO: distance_to fails at 1e9 units.
	var dist_val = round(10*loc.distance_to(loc_cube))
	var result_d = p.ui_readouts.get_magnitude_units(dist_val)
	marker.get_node("Text").text = "Origin: "\
			+str(round(result_d[0]))+ " " + result_d[1]

	
	#marker2.visible = not get_viewport().get_camera().is_position_behind(loc2)
	#marker2.rect_position = get_viewport().get_camera().unproject_position(loc2)
	#marker2.text = "Monolith: "+str(loc.distance_to(loc2))
