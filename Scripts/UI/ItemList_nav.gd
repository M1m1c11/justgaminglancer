extends ItemList

onready var p = get_tree().get_root().get_node("Main/Paths")
onready var coordinates_bank = p.common_resources.systems_coordinates_bank_1

var selected = 0

# Fetch a fresh list of markers whenever nav button is pressed.
func _ready():
	# ============================= Connect signals ===========================
	p.signals.connect("sig_fetch_markers", self, "is_fetch_markers")
	p.signals.connect("sig_target_clear", self, "is_target_clear")
	p.signals.connect("sig_autopilot_disable", self, "is_autopilot_disable")
	p.signals.connect("sig_system_spawned", self, "is_system_spawned")
	# =========================================================================
	
	self.ensure_current_is_visible()


# Update markers every time you open a nav list.
func is_fetch_markers():
	# First clear the list of previous items.
	self.clear()
			
	# Fetch a fresh list of markers.
	# TODO: add custom / temporary coordinates for local space.

	for coordinates in coordinates_bank.get_children():
		
		# Count ID.
		var id = self.get_item_count()
			
		# Add item with the node name.
		self.add_item(coordinates.get_name(), null, true)
		
		# Disable tooltips.
		self.set_item_tooltip_enabled(id, false)
		
		# Attach data to the item.
		self.set_item_metadata(id, coordinates)
	
	# Sort the list by name
	# self.sort_items_by_text()


func _on_ItemList_nav_visibility_changed():
	# Preserve apparent selection even when the list is hidden and called again.
	if self.visible and p.ship_state.aim_target_locked:
		self.select(selected)

	# TODO: Also clear selection when target lock is removed.

func is_target_clear():
	self.unselect_all()

# Perform marker refreshing upon arrival in order to get markers in global / local
func is_autopilot_disable():
	is_fetch_markers()


func _on_ItemList_nav_item_selected(index):
	selected = index
	var coordinates = self.get_item_metadata(index)
	#print(index, " | ", coordinates)
	
	# Set space coordinates and emit a signal to spawn a system there.
	p.common_space_state.system_coordinates = coordinates
	p.signals.emit_signal("sig_system_coordinates_selected")
	
	# Set ship targeting system onto marker.
	#p.ship_state.aim_target = marker
	#p.ship_state.aim_target_locked = true
	
func is_system_spawned(position_3d):
	# Set ship targeting system onto marker.
	p.ship_state.aim_target = position_3d
	p.ship_state.aim_target_locked = true
