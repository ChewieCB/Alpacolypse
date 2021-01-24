class_name Sheep
extends KinematicBody
# Helper class for the Sheep scene's scripts

onready var skin = $SheepSkin
onready var rigid_skin = $SheepRigid/SheepSkin
onready var state_machine: StateMachine = $StateMachine
onready var nav: Navigation = get_parent()
onready var player: Player = get_node("../../Player")

onready var sheep_rigid: RigidBody = $SheepRigid
# Timers
onready var idle_timer: Timer = $IdleTimer
onready var graze_timer: Timer = $GrazeTimer
onready var rigid_timer: Timer = $RigidTimer
# RayCasts
onready var floor_cast: RayCast = $SheepRigid/FloorCast

onready var tween: Tween = $Tween

export (float) var min_graze_time = 2.0
export (float) var max_graze_time = 6.0


func _ready():
	sheep_rigid.sleeping = true
	sheep_rigid.friction = 10
	sheep_rigid.get_node("CollisionShape").disabled = true

