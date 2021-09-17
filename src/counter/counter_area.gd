extends Area
class_name CounterArea

signal area_count_changed(value)
signal sheep_sacrificed(body)

var current_count := 0 setget _set_current_count, _get_current_count

export (int) var max_count

var is_sacrificial := false

onready var ui = $UI/SheepCounterUI


func _ready():
	yield(owner, "ready")
	
	# Hide dev zone meshes in-game
	if not Engine.editor_hint:
		visible = false
	
	current_count = get_sheep_in_area()


func get_sheep_in_area():
	var sheep_in_area = get_overlapping_bodies().size()
	if not sheep_in_area:
		return 0
	return sheep_in_area


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
		yield(body.state_machine, "transitioned")
		if is_sacrificial:
			emit_signal("sheep_sacrificed", body)
			body.queue_free()


func _on_CounterArea_body_exited(body):
	if body is Sheep:
		if is_sacrificial:
			return
		_set_current_count(current_count - 1)

#

func _set_current_count(value):
	current_count = value
	ui.label.text = str(current_count)
	emit_signal("area_count_changed", current_count)


func _get_current_count():
	return current_count

