extends SheepState
# Basic state when the sheep is moving around until jumping or lack of input


func physics_process(delta: float):
	_parent.physics_process(delta)
	if sheep.is_on_floor() or sheep.is_on_wall():
		if _parent.velocity.length() < 0.01:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")


func enter(msg: Dictionary = {}):
	# skin.transition
	# skin.is_moving = true
	
	_parent.enter(msg)


func exit():
#	_parent.path = []
#	_parent.path_node = 0
	# skin.is_moving = false
	_parent.exit()
