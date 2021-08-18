extends State
# State for when the player collides with an object whilst charging

export var max_speed = 40.0
export var move_speed = 40.0
export var gravity = -80.0
export var jump_impulse = 30
export (float, 0.1, 20.0, 0.1) var rotation_speed_factor := 10.0

export var knockback_inertia = 200

var knockback_velocity
var skin


func enter(msg: Dictionary = {}):
	# Disable player input
	GlobalFlags.PLAYER_CONTROLS_ACTIVE = false
	# 
	skin = _actor.skin
	skin.transition_to(skin.States.BONK)
	#
	_parent.enter()
	# Zero the parent movements
	_parent.velocity = Vector3.ZERO
	# Apply the speeds for the knockback
	_parent.max_speed = max_speed
	_parent.move_speed = move_speed
	_parent.jump_impulse = jump_impulse
	_parent.rotation_speed_factor = rotation_speed_factor
	
	knockback_velocity = msg["trajectory"]


func unhandled_input(_event: InputEvent):
	pass


func physics_process(delta: float):
	if _actor.is_on_floor() and knockback_velocity.y < 0:
		_state_machine.transition_to("Movement/Idle")
#
	knockback_velocity.y += delta * gravity
	_actor.move_and_slide(knockback_velocity, Vector3.UP, false, 4, 0.785398, false)


func exit():
	# Re-enable player input
	GlobalFlags.PLAYER_CONTROLS_ACTIVE = true
	_parent.exit()
