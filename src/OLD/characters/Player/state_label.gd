extends Spatial

var state_machine
var idle_timer


func _ready():
	yield(owner, "ready")
	state_machine = owner.state_machine
	if owner is Sheep:
		idle_timer = owner.idle_timer

func _process(_delta):
	if state_machine:
		$StateLabel/Label.text = state_machine._state_name
	if idle_timer:
		$StateLabel/TimerLabel.text = str(idle_timer.time_left)
