extends State
# State for when the player is falling AND charging

onready var coyote_time = Timer.new()
onready var was_on_floor = false

var max_speed = 40.0
var move_speed = 40.0
var gravity = -100.0
var jump_impulse = 140
var rotation_speed_factor := 6.0

export var charge_inertia = 800

var velocity := Vector3.ZERO
var camera_pivot
var goal_quaternion


func enter(msg: Dictionary = {}):
	_parent.enter()
	_parent.velocity.y = 0
	_parent.max_speed = max_speed
	_parent.move_speed = move_speed
	_parent.jump_impulse = jump_impulse
	_parent.rotation_speed_factor = rotation_speed_factor
	
	match msg:
		{"was_on_floor": var _was_on_floor}:
			was_on_floor = _was_on_floor
	# Add coyote timer if falling off a ledge
	if was_on_floor:
		coyote_time.one_shot = true
		coyote_time.wait_time = 0.2
		if not coyote_time.is_connected("timeout", self, "_on_coyote_time_timeout"):
			coyote_time.connect("timeout", self, "_on_coyote_time_timeout")
		add_child(coyote_time)
		coyote_time.start()


func unhandled_input(_event: InputEvent):
	pass


func physics_process(delta: float):
	_parent.physics_process(delta)
	
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
	else:
		# Coyote Time jumping
		if Input.is_action_pressed("p1_jump") and not coyote_time.is_stopped():
			coyote_time.stop()
			_state_machine.transition_to(
				"Movement/ChargeJumping",
				{"was_on_floor": _actor.is_on_floor()}
			)
		elif Input.is_action_just_released("p1_charge"):
			_state_machine.transition_to(
				"Movement/Falling",
				{"was_on_floor": _actor.is_on_floor()}
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
	_parent.exit()


func _on_coyote_time_timeout():
	remove_child(coyote_time)

