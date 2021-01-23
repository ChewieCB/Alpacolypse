extends SheepState
# Parent state for all movement-related states for the Sheep
# Holds all of the base movement logic
# Child states can override this states's functions or change its properties
# This keeps the logic grouped in one location

export var max_speed = 7.0
export var move_speed = 4.0
export var gravity = -80.0
export var jump_impulse = 25
export (float, 0.1, 20.0, 0.1) var rotation_speed_factor := 10.0

export (int, 0, 200) var inertia = 100

var velocity := Vector3.ZERO

# NavMesh vars
var path = []
var path_node = 0


func move_to_point(target_position):
	path = nav.get_simple_path(sheep.global_transform.origin, target_position)
	path_node = 0


func physics_process(delta: float):
	var move_direction = Vector3.ZERO
	
	# Move along nav path if it exists
	if path_node < path.size():
		move_direction = (path[path_node] - sheep.global_transform.origin)
		if move_direction.length() < 1:
			path_node += 1
		else:
			move_direction = move_direction.normalized()
			move_direction.y = 0
			# skin.move_direction = move_direction
			
			# Rotation
			if move_direction:
				var target_direction = sheep.transform.looking_at(sheep.global_transform.origin + move_direction, Vector3.UP)
				sheep.transform = sheep.transform.interpolate_with(target_direction, rotation_speed_factor * delta)

	# Movement
	velocity = calculate_velocity(velocity, move_direction, delta)
	velocity = sheep.move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, false)

	handle_rigid_collisions(inertia)

	# Find the nearest tuft of grass and set it as a target point
#	elif path_node > path.size():
#		var grass_tufts = get_tree().get_nodes_in_group("grass_tufts")
#		var closest_tuft = grass_tufts.sort_custom(self, "sort_closest_to_sheep")[0]
#		move_to_point(closest_tuft.global_transform.origin)


func calculate_velocity(velocity_current: Vector3, move_direction: Vector3, delta: float):
	var velocity_new = move_direction * move_speed
	if velocity_new.length() > max_speed:
		velocity_new = velocity_new.normalized() * max_speed
	velocity_new.y = velocity_current.y + gravity * delta
	
	return velocity_new


func enter(msg: Dictionary = {}):
	match msg:
		{"tuft_pos": var t}:
			move_to_point(t)
	# skin.transition_to


func exit():
	pass


func sort_closest_to_sheep(a, b):
	var sheep_origin = sheep.global_transform.origin
	var distance_to_a = sheep_origin.distance_to(a.global_transform.origin)
	var distance_to_b = sheep_origin.distance_to(b.global_transform.origin)
	if distance_to_a < distance_to_b:
		return true
	return false


func handle_rigid_collisions(inertia):
	for index in sheep.get_slide_count():
		var collision = sheep.get_slide_collision(index)
		if collision.collider is RigidBody:
			collision.collider.apply_central_impulse(-collision.normal * inertia)


func _on_GrazeDetectionArea_body_entered(body):
	var known_tufts = get_tree().get_nodes_in_group("grass_tufts")
	if body in get_tree().get_nodes_in_group("grass_tufts"):
		_state_machine.transition_to("Move/Graze", {"tuft": body})
