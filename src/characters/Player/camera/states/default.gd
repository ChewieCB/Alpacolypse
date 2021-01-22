extends CameraState
# Rotates the camera around the character, delegating all the work to its parent state


func unhandled_input(event: InputEvent):
	if event.is_action_pressed("p1_charge"):
		_state_machine.transition_to("Camera/Charge")
	elif event.is_action_pressed("p1_toggle_aim"):
		_state_machine.transition_to("Camera/Aim")
	else:
		_parent.unhandled_input(event)


func process(delta: float):
	_parent.process(delta)
