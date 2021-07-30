extends Position3D

onready var camera = $Camera

var look_sensitivity = 15.0
var min_look_angle = -20.0
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


func _process(delta):
	var yaw_dir = mouse_delta.x
	var pitch_dir = mouse_delta.y
	# Rotate the camera pivot accordingly
	var camera_rotation = Vector3(0, yaw_dir, pitch_dir) * look_sensitivity * delta
	rotation_degrees.y += camera_rotation.y
#	rotation_degrees.y = clamp(rotation_degrees.y, min_look_angle, max_look_angle)
	
	rotation_degrees.z += camera_rotation.z
	rotation_degrees.z = clamp(rotation_degrees.z, min_look_angle, max_look_angle)
	
	mouse_delta = Vector2.ZERO

