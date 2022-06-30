extends ItemList

onready var p = get_tree().get_root().get_node("Main/Paths")
onready var markers = p.common_space_state.markers

var selected = 0

# Fetch a fresh list of markers whenever nav button is pressed.
func _ready():
	# ============================= Connect signals ===========================
	p.signals.connect("sig_fetch_markers", self, "is_fetch_markers")
	p.signals.connect("sig_target_clear", self, "is_target_clear")
	p.signals.connect("sig_autopilot_disable", self, "is_autopilot_disable")
	# =========================================================================
	
	self.ensure_current_is_visible()


# Update markers every time you open a nav list.
func is_fetch_markers():
	# First clear the list of previous items.
	self.clear()
			
	# Fetch a fresh list of markers.
	markers = p.common_space_state.markers

	for marker in markers:
		
		# Count ID.
		var id = self.get_item_count()
			
		# Add item with the node name.
		self.add_item(marker.get_name(), null, true)
		
		# Disable tooltips.
		self.set_item_tooltip_enabled(id, false)
		
		# Attach data to the item.
		self.set_item_metadata(id, marker)
	
	# Sort the list by name
	self.sort_items_by_text()


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
	var marker = self.get_item_metadata(index)
	#print(index, " | ", marker)
	
	# Set ship targeting system onto marker.
	p.ship_state.aim_target = marker
	p.ship_state.aim_target_locked = true
