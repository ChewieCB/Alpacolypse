extends State
class_name CameraState
# Base type for the camera's rig state classes. Contains boilerplate code to
# get autocompletion and type hints

var camera_rig: CameraRig


func _ready():
	yield(owner, "ready")
	camera_rig = owner
