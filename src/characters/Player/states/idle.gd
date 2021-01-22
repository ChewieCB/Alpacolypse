extends PlayerState
# State for when there is no movement input
# Supports triggering jump after the player has started to fall


func unhandled_input(event: InputEvent):
	_parent.unhandled_input(event)


func physics_process(delta: float):
	_parent.physics_process(delta)
	if player.is_on_floor() and _parent.velocity.length() > 0.01:
		_state_machine.transition_to("Move/Run")
	elif not player.is_on_floor():
		_state_machine.transition_to("Move/Air")


func enter(msg: Dictionary = {}):
	_parent.velocity = Vector3.ZERO
	# skin.transition_to
	_parent.enter()


func exit():
	_parent.exit()
