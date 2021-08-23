extends State
# State for when the sheep is contained within a count zone

var skin


func enter(_msg: Dictionary = {}):
	skin = _actor.skin
	_parent.velocity = Vector3.ZERO
	_parent.path = null
	_parent.enter()
	
	skin.transition_to(skin.States.IDLE)


func physics_process(delta: float):
	_parent.physics_process(delta)


func exit():
	_parent.exit()

