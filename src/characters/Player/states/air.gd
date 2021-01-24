extends PlayerState
# State for when the player is jumping and falling


func unhandled_input(event: InputEvent):
	if not player.is_on_floor():
		if event.is_action_pressed("p1_charge"):
			# TODO - create a charge jump state instead of trying to handle this in one air state
			_state_machine.transition_to("Move/ChargeJump", {velocity = _parent.velocity, jump_impulse = Vector3(1, 5, 0)})


func physics_process(delta: float):
	_parent.physics_process(delta)
	
	if player.is_on_floor():
		_state_machine.transition_to("Move/Idle")
	elif player.is_on_ceiling():
		_parent.velocity.y = 0


func enter(msg: Dictionary = {}):
	# Store the initial velocity
	match msg:
		{"velocity": var v, "jump_impulse": var ji}:
			_parent.velocity = v + Vector3(0, ji, 0)
	skin.transition_to(skin.States.JUMP)
	_parent.enter()


func exit():
	skin.transition_to(skin.States.LAND)
	_parent.exit()
