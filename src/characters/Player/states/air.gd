extends PlayerState
# State for when the player is jumping and falling


func physics_process(delta: float):
	_parent.physics_process(delta)
	
	if player.is_on_floor():
		_state_machine.transition_to("Move/Idle")
	elif player.is_on_ceiling():
		_parent.velocity.y = 0


func enter(msg: Dictionary = {}):
	match msg:
		{"velocity": var v, "jump_impulse": var ji}:
			_parent.velocity = v + Vector3(0, ji, 0)
		{"velocity": var v, "charge_jump_impulse": var ji}:
			_parent.velocity = v + Vector3(ji.x, ji.y, ji.z)
	# skin.transition_to
	_parent.enter()


func exit():
	_parent.exit()
