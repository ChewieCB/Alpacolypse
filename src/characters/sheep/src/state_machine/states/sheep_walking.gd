extends State
# Basic state when the sheep is moving around until jumping or lack of input

onready var skin


func enter(msg: Dictionary = {}):
	skin = _actor.skin
	# Get random point and set a path to it
	var target_point = _parent.get_random_target_in_range()
	_parent.move_to_point(target_point)
	_parent.enter(msg)
	skin.transition_to(skin.States.WALK)


func physics_process(delta: float):
	_parent.physics_process(delta)
	if _parent.path_node == _parent.path.size():
		_state_machine.transition_to("Movement/Idle")

func exit():
	_parent.exit()
