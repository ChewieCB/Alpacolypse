extends State
# State for when the player is jumping AND charging

var max_speed = 40.0
var move_speed = 40.0
var gravity = -70.0
var jump_impulse = 110
var rotation_speed_factor := 6.0

export var charge_inertia = 800

var skin
var velocity := Vector3.ZERO

export var jump_velocity = 30


func enter(_msg: Dictionary = {}):
	skin = _actor.skin
	_parent.enter()
	_parent.max_speed = max_speed
	_parent.move_speed = move_speed
	_parent.jump_impulse = jump_impulse
	_parent.rotation_speed_factor = rotation_speed_factor
	_parent.velocity.x *= 4
	_parent.velocity.z *= 4
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
		if Input.is_action_pressed("p1_charge"):
			# Charge Falling
			_state_machine.transition_to(
				"Movement/ChargeFalling",
				{"was_on_floor": false}
			)
		else:
			_state_machine.transition_to(
				"Movement/Falling",
				{"was_on_floor": false}
			)
	elif Input.is_action_just_released("p1_charge"):
		_state_machine.transition_to(
			"Movement/Falling",
			{"was_on_floor": false}
		)
	
	if _actor.knockback_raycast.is_colliding():
		var body = _actor.knockback_raycast.get_collider()
		_state_machine.transition_to(
			"Movement/Knockback", 
			{
				"trajectory": _actor.calcualate_charge_trajectory(
					body, 
					20.0,
					gravity,
					true
				)
			}
		)


func exit():
	_parent.exit()
