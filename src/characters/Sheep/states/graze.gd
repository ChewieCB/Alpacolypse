extends SheepState
# State for Sheep grazing on grass
#
# Play the grazing animation for an amount of time, then queue free the 
# grass tuft and exit the state

var current_tuft
var grazing_complete


func physics_process(delta: float):
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}):
	grazing_complete = false
	# Clear any velocity and path vars
	_parent.velocity = Vector3.ZERO
	
	match msg:
		{"tuft": var t}:
			current_tuft = t
	# Set the graze timer to a random new value
	randomize()
	var new_graze_time = rand_range(sheep.min_graze_time, sheep.max_graze_time)
	graze_timer.wait_time = new_graze_time
	graze_timer.start()
	# skin.transition_to
	_parent.enter()


func exit():
	# Remove the tuft of grass that was being munched on
	if current_tuft and grazing_complete:
		current_tuft.queue_free()
		current_tuft = null
	_parent.path = []
	_parent.path_node = 0
	_parent.exit()


func _on_GrazeTimer_timeout():
	grazing_complete = true
#	if _state_machine.state == self:
#	if sheep.global_transform.origin.distance_to(closest_tuft.global_transform.origin) < 30:
	# Find if there are any grass tufts nearby
	var grass_tufts = get_tree().get_nodes_in_group("grass_tufts")
	if current_tuft:
		grass_tufts.erase(current_tuft)
	grass_tufts.sort_custom(self, "sort_closest_to_sheep")
	var closest_tuft = grass_tufts[0]
	_state_machine.transition_to("Move/Run", {"tuft_pos": closest_tuft.global_transform.origin})
