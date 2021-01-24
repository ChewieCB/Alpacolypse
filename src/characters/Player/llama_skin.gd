extends Spatial
class_name LlamaSkin
# Controls the animation tree's transitions for this animated character

# it has a signal connected to the player state machine, and uses the resulting 
# staet names to translate them into the states for the animation tree

enum States { IDLE, IDLE2, WALK, CHARGE, BONK, JUMP, LAND }

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_tree: AnimationTree = $AnimationTree
onready var _playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

var move_direction := Vector3.ZERO setget set_move_direction
var is_moving := false setget set_is_moving


func _ready():
	yield(owner, "ready")
	animation_player.playback_active = true
	animation_tree.active = true
	_playback.start("Idle")
	print(_playback.is_playing())


func set_move_direction(direction: Vector3):
	move_direction = direction
#	animation_tree["parameters/"]


func set_is_moving(value: bool):
	is_moving = value


func transition_to(state_id: int):
	match state_id:
		States.IDLE:
			_playback.travel("Idle")
		States.IDLE2:
			_playback.travel("Idle2")
		States.WALK:
			_playback.travel("Walk")
		States.CHARGE:
			_playback.travel("Charge")
		States.BONK:
			_playback.travel("Bonk")
		States.JUMP:
			_playback.travel("Jump")
		States.LAND:
			_playback.travel("Land")
		_:
			_playback.travel("Idle")

