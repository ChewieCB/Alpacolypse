extends Spatial

var state_machine: StateMachine
var idle_timer: Timer


func _ready():
	yield(owner, "ready")
	state_machine = owner.state_machine
	idle_timer = owner.idle_timer

func _process(_delta):
	if state_machine:
		$StateLabel/Label.text = state_machine._state_name
	if idle_timer:
		$StateLabel/TimerLabel.text = str(idle_timer.time_left)
