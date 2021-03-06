extends Node
class_name CounterManager

# Signals for various levels of fullness
signal count_empty
signal count_changed(value)
signal count_full(max_value)

export (bool) var is_sacrificial = false

# Zones
onready var linked_zones := get_children()
# Sheep
onready var sheep_scene = preload("res://src/characters/sheep/src/Sheep.tscn")
#
export (NodePath) var sheep_node_path
onready var sheep_node = get_node(sheep_node_path)
onready var sheep_array = sheep_node.get_children()
var sheep_origin_points = []

# Sheep Counts
var combined_current_count := 0 setget _set_combined_current_count, _get_combined_current_count
onready var total_count = sheep_node.get_child_count()


func _ready():
	yield(owner, "ready")
	# Prepare the initial counts
	total_count = sheep_node.get_child_count()
	# Connect the count signals from each zone
	if not linked_zones:
		push_warning("%s has no CounterZones linked to it!" % self.name)
	for _zone in linked_zones:
		_zone.connect("area_count_changed", self, "_set_combined_current_count")
		_zone.is_sacrificial = is_sacrificial
		_zone.connect("sheep_sacrificed", self, "_remove_sheep_from_array")
	# Cache the origin points of each sheep so we can re-spawn them on reset
	for _sheep in sheep_array:
		sheep_origin_points.append(_sheep.global_transform.origin)


func reset_sheep():
	"""
	This is method will need to be extended for the specific use
	case.
	"""
	# If we are sacrificing the sheep, some sheep will have been removed from
	# the array, so we re-instance them here
	for i in range(sheep_array.size()):
		var _sheep = sheep_array[i]
		if _sheep == null:
			_sheep = sheep_scene.instance()
			sheep_node.add_child(_sheep)
			sheep_array[i] = _sheep
		
		_sheep.global_transform.origin = sheep_origin_points[i]
		_sheep.movement_state.reset_path()
		_sheep.state_machine.transition_to("Movement/Idle")
	
	# If the array size is now different from the total count (derived from
	# the original count) we have fucked up
	assert(sheep_array.size() == total_count)


func reset_count():
	_set_combined_current_count(0)
	# Update zones
	for zone in linked_zones:
		zone._set_current_count(0)


func _remove_sheep_from_array(body):
	var sheep_index = sheep_array.find(body)
	if sheep_index != -1:
		# Set it to null so we can keep the indices in order for respawning
		sheep_array[sheep_index] = null


func _set_combined_current_count(value):
	# Pro tip - don't use this to do fucky shit, just keep base functionality
	# and emit signals.
	combined_current_count = value
	
	emit_signal("count_changed", combined_current_count)
	if combined_current_count == total_count:
		emit_signal("count_full", total_count)
	elif combined_current_count == 0:
		emit_signal("count_empty")


func _get_combined_current_count():
	var _count = 0
	for zone in linked_zones:
		_count += zone.current_count
	return _count

