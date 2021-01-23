tool
class_name Sheep
extends KinematicBody
# Helper class for the Sheep scene's scripts

onready var skin = $MeshInstance
onready var state_machine: StateMachine = $StateMachine
onready var nav: Navigation = get_parent()
onready var player: Player = get_node("../../Player")

onready var sheep_rigid: RigidBody = $SheepRigid
# Timers
onready var idle_timer: Timer = $IdleTimer
onready var graze_timer: Timer = $GrazeTimer

onready var tween: Tween = $Tween

export (float) var min_graze_time = 2.0
export (float) var max_graze_time = 6.0


func _ready():
	sheep_rigid.sleeping = true
	sheep_rigid.friction = 10
	sheep_rigid.get_node("CollisionShape").disabled = true


func _process(_delta):
	if idle_timer.wait_time > 0:
		$StateLabelNode/StateLabel/Label.text += " : %s" % [idle_timer.wait_time]
