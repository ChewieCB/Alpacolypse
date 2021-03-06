extends Spatial
class_name SheepSkin
# Controls the animation tree's transitions for this animated character

# it has a signal connected to the player state machine, and uses the resulting 
# staet names to translate them into the states for the animation tree

enum States { IDLE, IDLE2, WALK, RUN, EAT_START, EAT, EAT_END, BONK, JUMP, ROLL, LAND }

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_tree: AnimationTree = $AnimationTree
onready var _playback = animation_tree["parameters/playback"]


func _ready():
	yield(owner, "ready")
	animation_tree.active = true
	_playback = animation_tree["parameters/playback"]
	_playback.start("Idle")


func transition_to(state_id: int):
	match state_id:
		States.IDLE:
			_playback.travel("Idle")
		States.IDLE2:
			_playback.travel("Idle2")
		States.WALK:
			_playback.travel("Walk")
		States.RUN:
			_playback.travel("Run")
		States.EAT_START:
			_playback.travel("EatStart")
		States.EAT:
			_playback.travel("EatIdle")
		States.EAT_END:
			_playback.travel("EatEnd")
		States.BONK:
			_playback.travel("Bonk")
		States.ROLL:
			_playback.travel("Roll")
		States.JUMP:
			_playback.travel("Jump")
		States.LAND:
			_playback.travel("Land")
		_:
			_playback.travel("Idle")

