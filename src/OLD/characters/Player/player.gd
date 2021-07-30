tool
class_name Player
extends KinematicBody
# Helper class for the Player scene's scripts to be able to have access to the
# camera and its orientation

onready var camera = $CameraRig
onready var skin: LlamaSkin = $LlamaSkin
onready var state_machine: StateMachine = $StateMachine
onready var back_bounce: RayCast = $BackBounce


func _get_configuration_warning():
	return "Missing camera node" if not camera else ""


func _unhandled_input(event):
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
