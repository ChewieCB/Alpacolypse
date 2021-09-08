extends State

var max_speed = 40.0
var move_speed = 40.0
var gravity = -70.0
var jump_impulse = 140
var rotation_speed_factor := 6.0

export var charge_inertia = 800

var skin
var audio_player
var velocity := Vector3.ZERO
var camera_pivot 
var goal_quaternion


func enter(_msg: Dictionary = {}):
	audio_player = _actor.audio_player
	skin = _actor.skin
	_parent.enter()
	_parent.max_speed = max_speed
	_parent.move_speed = move_speed
	_parent.jump_impulse = jump_impulse
	_parent.rotation_speed_factor = rotation_speed_factor
	audio_player.transition_to(audio_player.States.CHARGE)
	skin.transition_to(skin.States.CHARGE)


func physics_process(delta: float):
	_parent.physics_process(delta)
	
	# Idle
	if _parent.input_direction == Vector3.ZERO:
		_state_machine.transition_to("Movement/Idle")
	else:
		if _actor.is_on_floor():
			# Jumping
			if Input.is_action_pressed("p1_jump"):
				_state_machine.transition_to("Movement/ChargeJumping")
			elif Input.is_action_just_released("p1_charge"):
				_state_machine.transition_to("Movement/Walking")
		# Falling
		else:
			if _parent.velocity.y < 0:
				_state_machine.transition_to(
					"Movement/ChargeFalling",
					{"was_on_floor": true}
				)
	
	for _raycast in _actor.knockback_raycasts:
		if _raycast.is_colliding():
			var body = _raycast.get_collider()
			
			# Sheep Knockback
			if body is Sheep:
				var flung_velocity = _actor.calcualate_charge_trajectory(body, 40.0, -80.0, true)
				body.state_machine.transition_to("Movement/Flung", {"flung_velocity": flung_velocity})
				
				# Remove the trajectory when the sheep lands
				if not body.is_connected("landed", _actor, "clear_debug_trajectory"):
					body.connect("landed", _actor, "clear_debug_trajectory")
			
			# Player Knockback
			_state_machine.transition_to(
				"Movement/Knockback", 
				{
					"trajectory": _actor.calcualate_charge_trajectory(
						body, 
						20.0,
						gravity,
						false
					)
				}
			)
			break


func exit():
	audio_player.stop_audio()
	_parent.exit()

