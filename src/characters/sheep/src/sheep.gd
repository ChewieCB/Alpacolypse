extends KinematicBody
class_name Sheep

onready var state_machine = $StateMachine
onready var state_label = $StatusLabels/Viewport/StateLabel
onready var movement_state = $StateMachine/Movement
onready var skin = $SheepSkin
onready var collider = $CollisionShape

export (int, 2, 100) var wander_range = 20

var spawn_position := Vector3.ZERO

signal landed


func _ready():
	spawn_position = global_transform.origin


func respawn():
	self.global_transform.origin = spawn_position
	movement_state.reset_path()
	state_machine.transition_to("Movement/Idle")
