extends Area

signal area_count_changed(value)

var current_count := 0 setget _set_current_count, _get_current_count

export (int) var max_count

onready var ui = $UI/SheepCounterUI


func _ready():
	yield(owner, "ready")
	$UI/SheepCounterUI.global_transform.origin = global_transform.origin + Vector3(0, 10, 0)
	current_count = get_sheep_in_area()


func get_sheep_in_area():
	return get_overlapping_bodies().size()


func get_available_sheep():
	# TODO
	#
	# Return the number of sheep not currently in a counter area, we use this
	# for determining the current max_count (??)
	pass

# 

func _on_CounterArea_body_entered(body):
	if body is Sheep:
		_set_current_count(current_count + 1)
		body.state_machine.transition_to("Movement/Contained")


func _on_CounterArea_body_exited(body):
	if body is Sheep:
		_set_current_count(current_count - 1)

#

func _set_current_count(value):
	current_count = value
	ui.label.text = str(current_count)
	emit_signal("area_count_changed", current_count)


func _get_current_count():
	return current_count

