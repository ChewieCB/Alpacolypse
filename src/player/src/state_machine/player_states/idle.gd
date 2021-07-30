extends State
# State for when there is no movement input
# Supports triggering jump after the player has started to fall

var velocity := Vector3.ZERO


func enter(_msg: Dictionary = {}):
	_parent.velocity = Vector3.ZERO
	_parent.enter()


func unhandled_input(event: InputEvent):
	_parent.unhandled_input(event)


func physics_process(delta: float):
	_parent.physics_process(delta)
	if _actor.is_on_floor():
		# Stationary Jumping
		if Input.is_action_pressed("p1_jump"):
			if Input.is_action_pressed("p1_charge"):
				_state_machine.transition_to("Movement/ChargeJumping")
			else:
				_state_machine.transition_to("Movement/Jumping")
		if _parent.input_direction != Vector3.ZERO:
			# Walking
			if Input.is_action_pressed("p1_charge"):
				_state_machine.transition_to("Movement/Charging")
			else:
				for _input in ["p1_move_forwards", "p1_move_left", "p1_move_backwards", "p1_move_right"]:
					if Input.is_action_pressed(_input):
						_state_machine.transition_to("Movement/Walking")
		elif _parent.velocity.y < -0.1:
			_state_machine.transition_to(
				"Movement/Falling",
				{"was_on_floor": _actor.is_on_floor()}
			)


func exit():
	_parent.exit()
