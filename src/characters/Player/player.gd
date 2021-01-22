tool
class_name Player
extends KinematicBody
# Helper class for the Player scene's scripts to be able to have access to the
# camera and its orientation

onready var camera = $CameraRig
onready var skin = $MeshInstance
onready var state_machine: StateMachine = $StateMachine


func _get_configuration_warning():
	return "Missing camera node" if not camera else ""
