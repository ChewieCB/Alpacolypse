tool
extends Spatial
class_name CameraRig
# Accessor class that gives the nodes in the scene access to the player or
# some frequently used nodes in the scene itself

signal aim_fired(target_position)

onready var camera: InterpolatedCamera = $InterpolatedCamera
onready var spring_arm: SpringArm = $SpringArm
onready var aim_ray: RayCast = $InterpolatedCamera/AimRay
onready var aim_target: Sprite3D = $AimTarget

var player: KinematicBody

var zoom := 0.25 setget set_zoom

onready var _position_start: Vector3 = translation


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
