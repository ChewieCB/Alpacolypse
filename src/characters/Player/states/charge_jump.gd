extends PlayerState
# State for when the player is charging and falling

var max_speed = 24.0
var move_speed = 20.0
var gravity = -70.0
var jump_impulse = 80
var rotation_speed_factor := 6.0

export var charge_inertia = 800

var velocity := Vector3.ZERO


func unhandled_input(event: InputEvent):
	if event.is_action_released("p1_charge"):
		_state_machine.transition_to("Move/Air", {velocity = velocity, jump_impulse = 0})

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
	
	if player.is_on_floor():
		if Input.is_action_pressed("p1_charge"):
			_state_machine.transition_to("Move/Charge")
		else:
			_state_machine.transition_to("Move/Idle")
	elif player.is_on_ceiling():
		_parent.velocity.y = 0


func enter(msg: Dictionary = {}):
	# Store the initial velocity
	match msg:
		{"velocity": var v, "jump_impulse": var ji}:
			velocity = v + ji
	# skin.transition_to
	_parent.enter()


func exit():
	_parent.exit()


func handle_rigid_collisions(inertia):
	for index in player.get_slide_count():
		var collision = player.get_slide_collision(index)
		if collision.collider is RigidBody:
			collision.collider.apply_central_impulse(- collision.normal * inertia)


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
