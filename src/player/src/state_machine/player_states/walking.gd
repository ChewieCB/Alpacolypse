extends State
# Basic state when the player is moving around until jumping or lack of input

export var max_speed = 20.0
export var move_speed = 20.0
export var gravity = -80.0
export var jump_impulse = 30
export (float, 0.1, 20.0, 0.1) var rotation_speed_factor := 10.0

export (int, 0, 200) var inertia = 0

var skin
var audio_player
var velocity := Vector3.ZERO


func enter(_msg: Dictionary = {}):
	audio_player = _actor.audio_player
	skin = _actor.skin
	#
	_parent.enter()
	_parent.max_speed = max_speed
	_parent.move_speed = move_speed
	_parent.jump_impulse = jump_impulse
	_parent.rotation_speed_factor = rotation_speed_factor
	#
	audio_player.transition_to(audio_player.States.WALK)
	skin.transition_to(skin.States.WALK)


func unhandled_input(event: InputEvent):
	_parent.unhandled_input(event)


func physics_process(delta: float):
	_parent.physics_process(delta)
	# Idle
	if _parent.input_direction == Vector3.ZERO:
		_state_machine.transition_to("Movement/Idle")
	else:
		if _actor.is_on_floor():
			# Jumping
			if Input.is_action_pressed("p1_jump"):
				_state_machine.transition_to("Movement/Jumping")
			if Input.is_action_pressed("p1_charge"):
				_state_machine.transition_to("Movement/Charging")
		# Falling
		else:
			if _parent.velocity.y < 0:
				_state_machine.transition_to(
					"Movement/Falling",
					{"was_on_floor": true}
				)


func exit():
	audio_player.stop_audio()
	_parent.exit()







