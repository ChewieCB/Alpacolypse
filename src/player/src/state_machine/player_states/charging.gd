extends State

var max_speed = 40.0
var move_speed = 40.0
var gravity = -70.0
var jump_impulse = 140
var rotation_speed_factor := 6.0

#onready var tween := $Tween

export var charge_inertia = 800

var skin
var velocity := Vector3.ZERO


func enter(_msg: Dictionary = {}):
	skin = _actor.skin
	_parent.enter()
	_parent.max_speed = max_speed
	_parent.move_speed = move_speed
	_parent.jump_impulse = jump_impulse
	_parent.rotation_speed_factor = rotation_speed_factor
	skin.transition_to(skin.States.CHARGE)


func unhandled_input(_event: InputEvent):
	pass
#	if event.is_action_pressed("p1_jump"):
#		if Input.is_action_pressed("p1_charge"):
#			# TODO - create a charge jump state instead of trying to handle this in one air state
#			var jump_vector = jump_impulse * velocity * 10
#			jump_vector.y += 20
#			_state_machine.transition_to("Move/ChargeJump", {velocity = velocity, jump_impulse = jump_vector})
#	elif event.is_action_released("p1_charge"):
#		_state_machine.transition_to("Move/Run")


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
	pass


func calculate_velocity(velocity_current: Vector3, move_direction: Vector3, delta: float):
	var velocity_new = move_direction * move_speed
	if velocity_new.length() > max_speed:
		velocity_new = velocity_new.normalized() * max_speed
	velocity_new.y = velocity_current.y + gravity * delta
	
	return velocity_new


#func _on_ChargeHitBox_body_entered(body):
#	# Get the direction the player is facing
#	var force_direction = player.global_transform.origin.normalized()
#	var force_impulse = force_direction * 10
#	force_impulse.y += 20
#	# TODO - add a specific knockback state to mask crossover between bonk animation and movement
#	var bounceback_impulse = -force_direction * 10
#	# Chargeable objects
#	if _state_machine.state == self:
#		if body is Sheep:
#				body.state_machine.transition_to("Rigid", {"impulse": force_impulse})
#		elif body is RigidBody:
#			if body.get_parent() is Sheep:
#				body.get_parent().state_machine.transition_to("Rigid", {"impulse": force_impulse})
#			else:
#				# TODO - Don't let the player juggle things indefinitely, check that the 
#				# body is on the floor before allowing them to charge it
#				#
#				#
#				# Yeet the body
#				body.set_axis_velocity(force_impulse)
#		# Kick the player out of the charge state
#		_state_machine.transition_to("Move/Run")
#		player.camera.state_machine.transition_to("Camera/Default")
#		# Shove the player away from the body
#		skin.transition_to(skin.States.BONK)
#		# Back bounce ray cast to prevent this knockback from clipping the player
#		# into level geometry.
#		var _test0 = player.global_transform.origin + bounceback_impulse
#		back_bounce.cast_to = player.global_transform.origin + bounceback_impulse
#		back_bounce.force_raycast_update()
#		if not back_bounce.is_colliding():
#			tween.interpolate_property(
#				player, 'translation', player.global_transform.origin, player.global_transform.origin + bounceback_impulse, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT
#			)
#			tween.start()
