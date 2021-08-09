extends State
# Basic state when the sheep is moving around until jumping or lack of input


func enter(msg: Dictionary = {}):
	# Get random point and set a path to it
	var target_point = _parent.get_random_target_in_range()
	_parent.move_to_point(target_point)
	_parent.enter(msg)


func physics_process(delta: float):
	_parent.physics_process(delta)
	if _parent.path_node == _parent.path.size():
		_state_machine.transition_to("Movement/Idle")


func exit():
	_parent.exit()
