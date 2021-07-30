extends PlayerState
# Parent state for all movement-related states for the Player
# Holds all of the base movement logic
# Child states can override this states's functions or change its properties
# This keeps the logic grouped in one location

export var max_speed = 12.0
export var move_speed = 10.0
export var gravity = -80.0
export var jump_impulse = 25
export (float, 0.1, 20.0, 0.1) var rotation_speed_factor := 10.0

export (int, 0, 200) var inertia = 0

var velocity := Vector3.ZERO


func unhandled_input(event: InputEvent):
	if event.is_action_pressed("p1_jump"):
		if event.is_action_pressed("p1_charge"):
			_state_machine.transition_to("Move/ChargeJump", {velocity = velocity, jump_impulse = jump_impulse})
		else:
			_state_machine.transition_to("Move/Air", {velocity = velocity, jump_impulse = jump_impulse})
	elif event.is_action_pressed("p1_charge"):
		_state_machine.transition_to("Move/Charge")


func physics_process(delta: float):
	var input_direction = get_input_direction()
	
	# Calculate a move direction vector relative to the camera
	# The basis stores the (right, up, -forwards) vectors of our camera
	var forwards: Vector3 = player.camera.global_transform.basis.z * input_direction.z
	var right: Vector3 = player.camera.global_transform.basis.x * input_direction.x
	var move_direction := forwards + right
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
	move_direction.y = 0
	skin.move_direction = move_direction
	
	# Rotation
	if move_direction:
		var target_direction = player.transform.looking_at(player.global_transform.origin + move_direction, Vector3.UP)
		player.transform = player.transform.interpolate_with(target_direction, rotation_speed_factor * delta)
	
	# Movement
	velocity = calculate_velocity(velocity, move_direction, delta)
	velocity = player.move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, false)
	
	handle_rigid_collisions(inertia)


func enter(msg: Dictionary = {}):
	pass
#	player.camera.connect("aim_fired", self, "_on_Camera_aim_fired")


func exit():
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
			collision.collider.apply_central_impulse(-collision.normal * inertia)
