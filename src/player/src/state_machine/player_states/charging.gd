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
var camera_pivot 


func enter(_msg: Dictionary = {}):
	skin = _actor.skin
	_parent.enter()
	_parent.max_speed = max_speed
	_parent.move_speed = move_speed
	_parent.jump_impulse = jump_impulse
	_parent.rotation_speed_factor = rotation_speed_factor
	skin.transition_to(skin.States.CHARGE)
	
	camera_pivot = _actor.camera_pivot 


func physics_process(delta: float):
	_parent.physics_process(delta)
	
	# Lerp camera to collision rotation
	var current_quaternion = Quat(camera_pivot.global_transform.basis)
	var goal_quaternion = _actor.collision.global_transform.basis
	var midpoint = current_quaternion.slerp(goal_quaternion, 0.5)
	camera_pivot.global_transform.basis = Basis(midpoint)
	camera_pivot.rotation_degrees.z = 20
	
#	camera_pivot.rotation = camera_pivot.rotation.linear_interpolate(
#		Vector3(0, _actor.collision.rotation.y - PI/2, camera_pivot.rotation.z),
#		0.2
#	)
#	camera_pivot.rotation
	
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
	pass

