extends KinematicBody

onready var state_machine = $StateMachine
onready var state_label = $StatusLabels/Viewport/StateLabel
onready var skin = $SheepSkin
onready var collider = $CollisionShape

export (int, 2, 100) var wander_range = 25

signal landed

