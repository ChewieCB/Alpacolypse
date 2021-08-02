extends State
# State for when the player is jumping AND charging

var max_speed = 25.0
var move_speed = 30.0
var gravity = -70.0
var jump_impulse = 110
var rotation_speed_factor := 6.0

export var charge_inertia = 800

var velocity := Vector3.ZERO

export var jump_velocity = 20


func enter(_msg: Dictionary = {}):
	_parent.enter()
	_parent.max_speed = max_speed
	_parent.move_speed = move_speed
	_parent.jump_impulse = jump_impulse
	_parent.rotation_speed_factor = rotation_speed_factor
	_parent.velocity.x *= 4
	_parent.velocity.z *= 4
	_parent.velocity += Vector3(0, jump_velocity, 0)


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
	
	# Knockback on collision detection
	for index in _actor.get_slide_count():
		var collision = _actor.get_slide_collision(index)
		if collision.collider is CSGShape and collision.normal.y <= 0:
			# FIXME - Only knockback if the collision is head on
			var actor_global_translation = _actor.to_global(_actor.translation)
			var collision_angle = actor_global_translation.angle_to(collision.position)
			
			if  collision_angle > deg2rad(38) and collision_angle < deg2rad(105):
				_state_machine.transition_to(
					"Movement/Knockback", 
					{"collision_position": collision.position}
				)


func exit():
	_parent.exit()
