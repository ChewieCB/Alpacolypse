extends State

# State for when the player collides with a drowning zone, plays the drowning
# animation and respawns them.

var skin


func _ready():
	yield(owner, "ready")
	skin = _actor.skin
	_actor.tween.connect("tween_all_completed", self, "exit")


func enter(msg: Dictionary = {}):
	# Disable player input
	GlobalFlags.PLAYER_CONTROLS_ACTIVE = false
	GlobalFlags.CAMERA_CONTROLS_ACTIVE = false
	# 
	skin = _actor.skin
	skin.transition_to(skin.States.IDLE)
	_parent.enter()
	_parent.velocity = Vector3.ZERO
	_parent.input_direction = Vector3.ZERO
	_parent.move_direction = Vector3.ZERO
	#
	_actor.tween.interpolate_property(
		_actor.skin,
		'transform:origin',
		_actor.skin.transform.origin,
		_actor.skin.transform.origin - Vector3(0, 5, 0),
		1.8,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	_actor.tween.start()


func physics_process(delta: float):
	_parent.physics_process(delta)


func exit():
	# Re-enable player input
	GlobalFlags.PLAYER_CONTROLS_ACTIVE = true
	GlobalFlags.CAMERA_CONTROLS_ACTIVE = true
	# TODO - player respawn at last checkpoint
	#
	# Need to reset the transform of the skin since we move it during the 
	# drowning animation.
	skin.transform = Transform(
		Vector3.ZERO, 
		Vector3.ZERO, 
		Vector3.ZERO, 
		Vector3.ZERO
	)
	_actor.reset()

