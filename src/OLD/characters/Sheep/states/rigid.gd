extends SheepState
# 

export var max_speed = 7.0
export var move_speed = 4.0
export var gravity = -80.0
export var jump_impulse = 25
export (float, 0.1, 20.0, 0.1) var rotation_speed_factor := 10.0

export (float, 0.5, 3.0, 0.1) var exit_threshold := 2.5

export (int, 0, 200) var inertia = 100

var velocity := Vector3.ZERO

var has_been_hit = false

func physics_process(_delta: float):
	if sheep_rigid:
		floor_cast.cast_to = Vector3(0, -1, 0)
		floor_cast.force_raycast_update()
		if floor_cast.is_colliding():
			if abs(sheep_rigid.linear_velocity.y) < 0.01 and \
				abs(sheep_rigid.linear_velocity.x) < exit_threshold and \
				abs(sheep_rigid.linear_velocity.x) < exit_threshold:
				sheep_rigid.get_node("SheepSkin").transition_to(skin.States.LAND)
				_state_machine.transition_to("Move/Idle")
			else:
				rigid_timer.start()
				sheep_rigid.linear_damp = 1.5


func enter(msg: Dictionary = {}):
	match msg:
		{"impulse": var imp}:
			# Set the impulse
			var force_impulse = imp 
			
			# Hide/Disable collisions for the kinematic sheep
			sheep.skin.visible = false
			sheep.get_node("CollisionShape").disabled = true
			# Wake the rigid body version of the sheep
			sheep_rigid.sleeping = false
			sheep_rigid.get_node("CollisionShape").disabled = false
			sheep_rigid.visible = true
			sheep_rigid.linear_damp = 0.3
			
			# Set the rigid sheep's animation
#			sheep_rigid.get_node("SheepSkin").transition_to(skin.States.ROLL)
			
			# Yeet the sheep
			force_impulse.x *= 4
			force_impulse.z *= 4
			force_impulse.y *= 2
			sheep_rigid.set_axis_velocity(force_impulse)
	
	# skin.transition_to


func exit():
	rigid_timer.stop()
	if sheep and sheep_rigid:
		# Bring the kinematic sheep back to parity with the rigid sheep
		sheep.global_transform.origin = sheep_rigid.global_transform.origin
		sheep.rotation_degrees = Vector3.ZERO
		sheep.rotation_degrees.y = sheep_rigid.rotation_degrees.y
		# Reset the rigid sheep transform
		sheep_rigid.transform.origin = Vector3.ZERO
		sheep_rigid.rotation_degrees = Vector3.ZERO
		sheep_rigid.rotation_degrees.y = sheep.rotation_degrees.y
		# Show/Enable collisions for the kinematic sheep
		sheep.skin.visible = true
		sheep.get_node("CollisionShape").disabled = false
		# Put the rigid body version of the sheep to sleep
		sheep_rigid.sleeping = true
		sheep_rigid.get_node("CollisionShape").disabled = true
		sheep_rigid.visible = false



func _on_RigidTimer_timeout():
	_state_machine.transition_to("Move/Idle")
