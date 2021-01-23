extends SheepState
# State for when the sheep is jumping and falling


func physics_process(delta: float):
	_parent.physics_process(delta)
	
	if sheep.is_on_floor():
		_state_machine.transition_to("Move/Idle")
	elif sheep.is_on_ceiling():
		_parent.velocity.y = 0


func enter(msg: Dictionary = {}):
#	# Store the initial velocity
#	match msg:
#		{"velocity": var v, "jump_impulse": var ji}:
#			_parent.velocity = v + Vector3(0, ji, 0)
	# skin.transition_to
	_parent.enter()


func exit():
	_parent.exit()
