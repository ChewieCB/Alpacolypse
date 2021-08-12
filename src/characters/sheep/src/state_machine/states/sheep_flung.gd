extends State
# State for when there is no movement input
# Supports triggering jump after the Sheep has started to fall

var skin
var flung_velocity

export var gravity = -80.0


func enter(msg: Dictionary = {}):
	skin = _actor.skin
	skin.transition_to(skin.States.ROLL)
	_parent.path = null
	_parent.enter()
	# Disable collision with the player so we don't trigger the state multiple times
	_actor.set_collision_mask_bit(1, false)
	#
	if msg["flung_velocity"]:
		flung_velocity = msg["flung_velocity"]
	


func physics_process(delta: float):
	if _actor.is_on_floor() and flung_velocity.y < 0:
		_state_machine.transition_to("Movement/Idle")
#
	flung_velocity.y += delta * gravity
	_actor.move_and_slide(flung_velocity, Vector3.UP, false, 4, 0.785398, false)


func exit():
	# Re-enable collision with player
	_actor.set_collision_mask_bit(1, true)
	_parent.exit()

