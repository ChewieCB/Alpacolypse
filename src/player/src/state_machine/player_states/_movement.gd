extends State
# Parent state for all movement-related states for the Player
# Holds all of the base movement logic
# Child states can override this states's functions or change its properties
# This keeps the logic grouped in one location

signal align_charge_cam

# These should be fallback defaults
# TODO: Make these null and raise an exception to indicate bad State extension
#       to better separate movement vars.
export var max_speed = 0
export var move_speed = 20
export var gravity = -80.0
export var jump_impulse = 35
export (float, 0.1, 20.0, 0.1) var rotation_speed_factor := 2.0

export (int, 0, 200) var inertia = 0

var velocity := Vector3.ZERO
var input_direction = Vector3.ZERO
var move_direction = Vector3.ZERO

var camera_pivot = null
var goal_quaternion


func enter(msg: Dictionary = {}):
	# Camera Adjustments
	if _state_machine.state in _actor.charge_states:
		emit_signal("align_charge_cam")
		_actor.camera_pivot.enter_charge()


func unhandled_input(_event: InputEvent):
	pass


func physics_process(delta: float):
	# Debug Reset
	if Input.is_action_pressed("reset"):
		if GlobalFlags.PLAYER_CONTROLS_ACTIVE == true:
			get_tree().reload_current_scene()
	elif Input.is_action_pressed("quit"):
		GlobalFlags.PLAYER_CONTROLS_ACTIVE = true
		get_tree().quit()
	
	# Movement
	#
	if GlobalFlags.PLAYER_CONTROLS_ACTIVE:
		input_direction = get_input_direction()
	else:
		input_direction = Vector3.ZERO
	
	move_direction = calculate_movement_direction(input_direction, delta)
	
	velocity = calculate_velocity(velocity, move_direction, delta)
	velocity = _actor.move_and_slide(velocity, Vector3.UP, true, 4, 0.785398, false)
	
	# Readjust if the player is charging and turning whilst the tween is still going
	if _actor.camera_pivot.tween.is_active() and _actor.is_charging \
	and Vector3(
		Input.get_action_strength("p1_move_right") - Input.get_action_strength("p1_move_left"),
		0,
		Input.get_action_strength("p1_move_backwards") - Input.get_action_strength("p1_move_forwards")
	) != Vector3.ZERO:
		emit_signal("align_charge_cam")


func exit():
	if _state_machine.state in _actor.charge_states:
		_actor.camera_pivot.exit_charge()


func get_input_direction():
	var input_vector =  Vector3(
		Input.get_action_strength("p1_move_right") - Input.get_action_strength("p1_move_left"),
		0,
		Input.get_action_strength("p1_move_backwards") - Input.get_action_strength("p1_move_forwards")
	)
	# Charging always drives the player forwards
	if Input.is_action_pressed("p1_charge"):
		input_vector = _actor.collision.global_transform.origin
#		input_vector.z = -1
#		input_vector = input_vector.rotated(
#			Vector3.UP, _actor.collision.rotation.y
#		)
	
	return input_vector


func calculate_movement_direction(input_direction, delta):
	var forwards := Vector3.ZERO
	var right := Vector3.ZERO
	
	# Charging Movement
	if Input.is_action_pressed("p1_charge"):
		# If the player is charging, we want to move forwards in the direction
		# the skin is facing, with the camera pivot rotating to match this.
		
		forwards = Vector3.FORWARD.rotated(
			Vector3.UP, 
			_actor.collision.rotation.y
		)
		move_direction = forwards
		#
		if move_direction.length() > 1.0:
			move_direction = move_direction.normalized()
			move_direction.y = 0
		#
		var turning_speed = 3
		if Input.is_action_pressed("p1_move_left"):
			_actor.collision.rotate_y(turning_speed * delta)
			_actor.camera_pivot.rotate_y(turning_speed * delta)
			pass
		elif Input.is_action_pressed("p1_move_right"):
			_actor.collision.rotate_y(-turning_speed * delta)
			_actor.camera_pivot.rotate_y(-turning_speed * delta)
	
	# Regular Movement
	else:
		# Otherwise we calculate a move direction vector relative to the camera,
		# the basis stores the (right, up, -forwards) vectors of our camera.
		forwards = input_direction.z * _actor.camera.global_transform.basis.z
		right = input_direction.x * _actor.camera.global_transform.basis.x
		move_direction = forwards + right
		
		if move_direction.length() > 1.0:
			move_direction = move_direction.normalized()
			move_direction.y = 0
	
		# Rotation
		if move_direction != Vector3.ZERO:
			# Get the angle in the y-axis via atan2
			var movement_angle = atan2(move_direction.x, move_direction.z) + PI
			# lerp_angle prevents the flip-flopping between 0 and 360 degrees
			for element in _actor.rotateable:
				element.rotation.y = lerp_angle(
					element.rotation.y,
					movement_angle,
					0.2
				)
	
	return move_direction 


func calculate_velocity(velocity_current: Vector3, _move_direction: Vector3, delta: float):
	var velocity_new = move_direction * move_speed
	if velocity_new.length() > max_speed:
		velocity_new = velocity_new.normalized() * max_speed
	velocity_new.y = velocity_current.y + gravity * delta
	
	return velocity_new

