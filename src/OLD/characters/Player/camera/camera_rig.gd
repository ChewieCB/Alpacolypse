tool
extends Spatial
class_name CameraRig
# Accessor class that gives the nodes in the scene access to the player or
# some frequently used nodes in the scene itself

onready var camera: InterpolatedCamera = $InterpolatedCamera
onready var spring_arm: SpringArm = $SpringArm
onready var camera_target: Position3D = $SpringArm/CameraTarget
onready var aim_ray: RayCast = $InterpolatedCamera/AimRay
onready var aim_target: Sprite3D = $AimTarget
onready var state_machine: StateMachine = $StateMachine

var player: KinematicBody

var zoom := 0.25 setget set_zoom

# For reference
# const regular_translation := Vector3(0, 3, 3)
# const regular_rotation := Vector3(-20, 0, 0)

onready var _position_start: Vector3 = translation
onready var _rotation_start: Vector3 = rotation_degrees


func _ready():
	set_as_toplevel(true)
	yield(owner, "ready")
	player = owner


func _get_configuration_warning():
	return "Missing player node" if not player else ""


func set_zoom(value: float):
	zoom = clamp(value, 0.0, 1.0)
	if not spring_arm:
		yield(spring_arm, "ready")
	spring_arm.zoom = zoom
