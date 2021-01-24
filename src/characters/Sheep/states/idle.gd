extends SheepState
# State for when there is no movement input
# Supports triggering jump after the Sheep has started to fall


func unhandled_input(event: InputEvent):
	_parent.unhandled_input(event)


func physics_process(delta: float):
	_parent.physics_process(delta)
	if sheep.is_on_floor() and _parent.velocity.length() > 0.01:
		_state_machine.transition_to("Move/Run")
	elif not sheep.is_on_floor():
		_state_machine.transition_to("Move/Air")


func enter(msg: Dictionary = {}):
	_parent.velocity = Vector3.ZERO
	randomize()
	idle_timer.wait_time = rand_range(0.5, 7.2)
	idle_timer.start()
	# skin.transition_to
	_parent.enter()


func exit():
	_parent.exit()


func _on_IdleTimer_timeout():
	# Find if there are any grass tufts nearby
	var grass_tufts = get_tree().get_nodes_in_group("grass_tufts")
	grass_tufts.sort_custom(_parent, "sort_closest_to_sheep")
	var closest_tuft = grass_tufts[0]
#	var direction_to_tuft = sheep.global_transform.origin.direction_to(closest_tuft.global_transform.origin)
#	var target_tuft_point = closest_turf - direction_to_tuft
	if _state_machine.state == self:
#		if sheep.global_transform.origin.distance_to(closest_tuft.global_transform.origin) < 30:
		_state_machine.transition_to("Move/Run", {"tuft_pos": closest_tuft.global_transform.origin})
