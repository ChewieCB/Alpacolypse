extends Spatial

onready var camera = $Camera
onready var far_camera_collider = $MaxRayCast
onready var near_camera_collider = $MaxRayCast
onready var camera_collision_sphere = $Camera/Area

var look_sensitivity = 15.0
var min_look_angle = -40.0
var max_look_angle = 75.0


var mouse_delta = Vector2.ZERO

onready var actor = get_parent()


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Get pitch and yaw values from relative mouse movement
		mouse_delta = event.relative
		if not GlobalFlags.CAMERA_INVERT_X:
			mouse_delta.x *= -1
		if not GlobalFlags.CAMERA_INVERT_Y:
			mouse_delta.y *= -1


func _physics_process(_delta):
	if far_camera_collider.is_colliding():
		if near_camera_collider.is_colliding():
			camera.translation = near_camera_collider.cast_to
		else:
			camera.global_transform.origin = far_camera_collider.get_collision_point()
	else:
		camera.translation = far_camera_collider.cast_to


func _process(delta):
	var yaw_dir = mouse_delta.x
	var pitch_dir = mouse_delta.y
	# Rotate the camera pivot accordingly
	var camera_rotation = Vector3(0, yaw_dir, pitch_dir) * look_sensitivity * delta
	rotation_degrees.y += camera_rotation.y
	
	# Rotate the player meshes to face the new look direction
	var player_mesh = get_node("../DefaultCollisionShape")
	var charge_collider = get_node("../ChargeCollider")
	player_mesh.rotation_degrees.y += camera_rotation.y
	charge_collider.rotation_degrees.y += camera_rotation.y

	rotation_degrees.z += camera_rotation.z
	rotation_degrees.z = clamp(rotation_degrees.z, min_look_angle, max_look_angle)
	
	mouse_delta = Vector2.ZERO


