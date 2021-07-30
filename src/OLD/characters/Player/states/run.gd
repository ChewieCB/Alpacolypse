extends PlayerState
# Basic state when the player is moving around until jumping or lack of input


func unhandled_input(event: InputEvent):
	if event.is_action_pressed("p1_charge"):
		_state_machine.transition_to("Move/Charge")
	# Catch for when a player keeps holding a movement input after the knocback
	# of a charge.
	if skin._playback.get_current_node() != "Walk":
		skin.transition_to(skin.States.WALK)
	_parent.unhandled_input(event)


func physics_process(delta: float):
	_parent.physics_process(delta)
	if player.is_on_floor() or player.is_on_wall():
		if _parent.velocity.length() < 0.01:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")


func enter(_msg: Dictionary = {}):
	skin.transition_to(skin.States.WALK)
	# skin.is_moving = true
	_parent.enter()


func exit():
	# skin.is_moving = false
	_parent.exit()
