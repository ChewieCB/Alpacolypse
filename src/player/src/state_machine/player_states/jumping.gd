extends State
# State for when the player is jumping

export var jump_velocity = 20

var skin


func enter(_msg: Dictionary = {}):
	skin = _actor.skin
	_parent.enter()
	_parent.velocity.x *= 2
	_parent.velocity.z *= 2
	_parent.velocity += Vector3(0, jump_velocity, 0)
	skin.transition_to(skin.States.JUMP)


func unhandled_input(_event: InputEvent):
	pass


func physics_process(delta: float):
	_parent.physics_process(delta)
	if _actor.is_on_ceiling():
		_parent.velocity.y = 0
	# Transition to Falling at peak of jump
	if _parent.velocity.y <= 0:
		_state_machine.transition_to(
				"Movement/Falling",
				{"was_on_floor": false}
			)
	elif Input.is_action_pressed("p1_charge"):
		# Charge Falling
		_state_machine.transition_to(
			"Movement/ChargeFalling",
			{"was_on_floor": false}
		)


func exit():
	_parent.exit()
