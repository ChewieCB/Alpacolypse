extends PlayerState

var max_speed = 24.0
var move_speed = 20.0
var gravity = -70.0
var jump_impulse = 140
var rotation_speed_factor := 6.0

onready var tween := $Tween

export var charge_inertia = 800

var velocity := Vector3.ZERO


func unhandled_input(event: InputEvent):
	if event.is_action_pressed("p1_jump"):
		if Input.is_action_pressed("p1_charge"):
			# TODO - create a charge jump state instead of trying to handle this in one air state
			var jump_vector = jump_impulse * velocity * 10
			jump_vector.y += 20
			_state_machine.transition_to("Move/ChargeJump", {velocity = velocity, jump_impulse = jump_vector})
	elif event.is_action_released("p1_charge"):
		_state_machine.transition_to("Move/Run")
	# Falling
	else:
		if _parent.velocity.y < 0:
			_state_machine.transition_to(
				"Movement/ChargeFalling",
				{"was_on_floor": true}
			)


func physics_process(delta: float):
	var input_direction = get_input_direction()
	
	# Calculate a move direction vector relative to the camera
	# The basis stores the (right, up, -forwards) vectors of our camera
	var forwards: Vector3 = - player.camera.global_transform.basis.z
	var right: Vector3 = player.camera.global_transform.basis.x * input_direction.x
	var move_direction := forwards + right
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
	move_direction.y = 0
	# skin.move_direction = move_direction
	
	# Rotation
	if move_direction:
		var target_direction = player.transform.looking_at(player.global_transform.origin + move_direction, Vector3.UP)
		player.transform = player.transform.interpolate_with(target_direction, rotation_speed_factor * delta)
	
	# Movement
	velocity = calculate_velocity(velocity, move_direction, delta)
	velocity = player.move_and_slide(velocity, Vector3.UP)
	
	handle_rigid_collisions(charge_inertia)


func enter(_msg: Dictionary = {}):
#	skin.transform = skin.transform.rotated(Vector3(1, 0, 0), -PI/12)
	skin.transition_to(skin.States.CHARGE)


func exit():
#	skin.transform = skin.transform.rotated(Vector3(1, 0, 0), PI/12)
	pass
#	player.camera.disconnect("aim_fired", self, "_on_Camera_aim_fired")


static func get_input_direction():
	return Vector3(
		Input.get_action_strength("p1_move_right") - Input.get_action_strength("p1_move_left"),
		0,
		Input.get_action_strength("p1_move_backwards") - Input.get_action_strength("p1_move_forwards")
	)


func calculate_velocity(velocity_current: Vector3, move_direction: Vector3, delta: float):
	var velocity_new = move_direction * move_speed
	if velocity_new.length() > max_speed:
		velocity_new = velocity_new.normalized() * max_speed
	velocity_new.y = velocity_current.y + gravity * delta
	
	return velocity_new


func handle_rigid_collisions(inertia):
	for index in player.get_slide_count():
		var collision = player.get_slide_collision(index)
		if collision.collider is RigidBody:
			collision.collider.apply_central_impulse(- collision.normal * inertia)


func _on_ChargeHitBox_body_entered(body):
	# Get the direction the player is facing
	var force_direction = player.global_transform.origin.normalized()
	var force_impulse = force_direction * 10
	force_impulse.y += 20
	# TODO - add a specific knockback state to mask crossover between bonk animation and movement
	var bounceback_impulse = -force_direction * 10
	# Chargeable objects
	if _state_machine.state == self:
		if body is Sheep:
				body.state_machine.transition_to("Rigid", {"impulse": force_impulse})
		elif body is RigidBody:
			if body.get_parent() is Sheep:
				body.get_parent().state_machine.transition_to("Rigid", {"impulse": force_impulse})
			else:
				# TODO - Don't let the player juggle things indefinitely, check that the 
				# body is on the floor before allowing them to charge it
				#
				#
				# Yeet the body
				body.set_axis_velocity(force_impulse)
		# Kick the player out of the charge state
		_state_machine.transition_to("Move/Run")
		player.camera.state_machine.transition_to("Camera/Default")
		# Shove the player away from the body
		skin.transition_to(skin.States.BONK)
		# Back bounce ray cast to prevent this knockback from clipping the player
		# into level geometry.
		var _test0 = player.global_transform.origin + bounceback_impulse
		back_bounce.cast_to = player.global_transform.origin + bounceback_impulse
		back_bounce.force_raycast_update()
		if not back_bounce.is_colliding():
			tween.interpolate_property(
				player, 'translation', player.global_transform.origin, player.global_transform.origin + bounceback_impulse, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT
			)
			tween.start()
