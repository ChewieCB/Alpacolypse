extends State
# Parent state for all movement-related states for the Player
# Holds all of the base movement logic
# Child states can override this states's functions or change its properties
# This keeps the logic grouped in one location

# These should be fallback defaults
# TODO: Make these null and raise an exception to indicate bad State extension
#       to better separate movement vars.
export var max_speed = 0
export var move_speed = 20
export var gravity = -80.0
export var jump_impulse = 35
export (float, 0.1, 20.0, 0.1) var rotation_speed_factor := 10.0

export (int, 0, 200) var inertia = 0

var velocity := Vector3.ZERO
var input_direction = Vector3.ZERO
var move_direction = Vector3.ZERO


func enter(_msg: Dictionary = {}):
	pass
#	player.camera.connect("aim_fired", self, "_on_Camera_aim_fired")


func unhandled_input(_event: InputEvent):
	pass


func physics_process(delta: float):
	# Debug Reset
	if Input.is_action_pressed("reset"):
		GlobalFlags.PLAYER_CONTROLS_ACTIVE = true
		get_tree().reload_current_scene()
	elif Input.is_action_pressed("quit"):
		GlobalFlags.PLAYER_CONTROLS_ACTIVE = true
		get_tree().quit()
	
	if GlobalFlags.PLAYER_CONTROLS_ACTIVE:
		input_direction = get_input_direction()
	# Calculate a move direction vector relative to the camera
	# The basis stores the (right, up, -forwards) vectors of our camera
	var forwards: Vector3 = input_direction.z * _actor.camera.global_transform.basis.z
	var right: Vector3 = input_direction.x * _actor.camera.global_transform.basis.x
	move_direction = forwards + right
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
	move_direction.y = 0
	#	skin.move_direction = move_direction
	
	# Rotation
#	if move_direction:
#		var target_direction = _actor.transform.looking_at(_actor.global_transform.origin + move_direction, Vector3.UP)
#		_actor.transform = _actor.transform.interpolate_with(target_direction, rotation_speed_factor * delta)
	
	# Movement
	velocity = calculate_velocity(velocity, move_direction, delta)
	velocity = _actor.move_and_slide(velocity, Vector3.UP, true, 4, 0.785398, false)


func exit():
	pass
#	player.camera.disconnect("aim_fired", self, "_on_Camera_aim_fired")


static func get_input_direction():
	return Vector3(
		Input.get_action_strength("p1_move_right") - Input.get_action_strength("p1_move_left"),
		0,
		Input.get_action_strength("p1_move_backwards") - Input.get_action_strength("p1_move_forwards")
	)


func calculate_velocity(velocity_current: Vector3, _move_direction: Vector3, delta: float):
	var velocity_new = move_direction * move_speed
	if velocity_new.length() > max_speed:
		velocity_new = velocity_new.normalized() * max_speed
	velocity_new.y = velocity_current.y + gravity * delta
	
	return velocity_new


#func handle_rigid_collisions(_inertia):
#	for index in player.get_slide_count():
#		var collision = player.get_slide_collision(index)
#		if collision.collider is RigidBody:
#			collision.collider.apply_central_impulse(-collision.normal * _inertia)
