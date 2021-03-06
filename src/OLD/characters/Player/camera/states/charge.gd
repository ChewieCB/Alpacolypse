extends CameraState
# Activates the aiming miode for the camera
# Moves the camera to the character's shoulder, and narrows the field of view
# Projects a target on the environment

onready var tween := $Tween

export var fov := 60.0
export var charge_translation := Vector3(0, 2, 2)
export var charge_rotation := Vector3(-10, 0, 0)


func unhandled_input(event: InputEvent):
	if event.is_action_released("p1_charge"):
		_state_machine.transition_to("Camera/Default")
#	elif event.is_action_pressed("p1_spit"):
#		_state_machine.transition_to("Camera/Default")
#		var target_position: Vector3 = (
#			camera_rig.aim_ray.get_collision_point()
#			if camera_rig.aim_ray.is_colliding()
#			else camera_rig.get_global_transform().origin
#		)
#		camera_rig.emit_signal("aim_fired", target_position)
	else:
		_parent.unhandled_input(event)


func process(delta: float):
	_parent.process(delta)


func enter(_msg: Dictionary = {}):
	# SpringArm sets height, CameraTarget sets angle
	camera_rig.spring_arm.translation = charge_translation
	camera_rig.spring_arm.rotation_degrees = charge_rotation
	tween.interpolate_property(
		camera_rig.camera, 'fov', camera_rig.camera.fov, fov, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	tween.start()


func exit():
	camera_rig.spring_arm.translation = camera_rig.spring_arm._position_start
	camera_rig.spring_arm.rotation_degrees = camera_rig._rotation_start
	tween.interpolate_property(
		camera_rig.camera,
		'fov',
		camera_rig.camera.fov,
		_parent.fov_default,
		0.5,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	tween.start()
