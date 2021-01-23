extends Spatial

var state_machine


func _ready():
	yield(owner, "ready")
	state_machine = get_parent().state_machine

func _process(_delta):
	if state_machine:
		$StateLabel/Label.text = state_machine._state_name
