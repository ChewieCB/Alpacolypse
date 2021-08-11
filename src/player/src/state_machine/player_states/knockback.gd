extends State
# State for when the player collides with an object whilst charging

export var max_speed = 30.0
export var move_speed = 40.0
export var gravity = -120.0
export var jump_impulse = 30
export (float, 0.1, 20.0, 0.1) var rotation_speed_factor := 10.0

export var knockback_inertia = 200

var timer


func enter(msg: Dictionary = {}):
	# Disable player input
	GlobalFlags.PLAYER_CONTROLS_ACTIVE = false
	_parent.enter()
	# Zero the parent movements
	_parent.velocity = Vector3.ZERO
	# Apply the speeds for the knockback
	_parent.max_speed = max_speed
	_parent.move_speed = move_speed
	_parent.jump_impulse = jump_impulse
	_parent.rotation_speed_factor = rotation_speed_factor
	# Knockback on collision detection
	for index in _actor.get_slide_count():
		var collision = _actor.get_slide_collision(index)
		if collision.collider and collision.normal.y <= 0:
			# FIXME - Only knockback if the collision is head on
			var actor_global_translation = _actor.to_global(_actor.translation)
			var collision_angle = actor_global_translation.angle_to(collision.position)

			# FIXME: figure out why this has a PI/16 offset?
			var camera_rotation_offset = _actor.camera_pivot.rotation.y - 3*PI - (PI/16)
			var collision_direction = Vector3.ONE.rotated(Vector3.UP, camera_rotation_offset)
			collision_direction.y = 0
			
			_parent.input_direction = collision_direction
			_parent.velocity = collision_direction * knockback_inertia
		
	# Movement timer
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(0.2)
	timer.connect("timeout", self, "_movement_timer_callback")
	add_child(timer)
	timer.start()


func unhandled_input(_event: InputEvent):
	pass


func physics_process(delta: float):
	_parent.physics_process(delta)
	# Lerping the knockback
	if not timer.is_stopped() and _parent.velocity != Vector3.ZERO:
		_parent.velocity = _parent.velocity.linear_interpolate(Vector3(0, _parent.velocity.y, 0), 0.6)
	if GlobalFlags.PLAYER_CONTROLS_ACTIVE:
		if _actor.is_on_floor():
			if _parent.input_direction == Vector3.ZERO:
				# Idle
				_state_machine.transition_to("Movement/Idle")
			else:
				if Input.is_action_pressed("p1_charge"):
					# Charging
					_state_machine.transition_to("Movement/Charging")
				else:
					# Walking
					_state_machine.transition_to("Movement/Walking")


func _movement_timer_callback():
	# Stop movement
	_parent.input_direction.x = 0
	_parent.input_direction.z = 0
	remove_child(timer)
	
	# Start control Release Timer
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(0.1)
	timer.connect("timeout", self, "_control_timer_callback")
	add_child(timer)
	timer.start()


func _control_timer_callback():
	# Re-enable player input
	GlobalFlags.PLAYER_CONTROLS_ACTIVE = true
	remove_child(timer)


func exit():
	_parent.exit()
