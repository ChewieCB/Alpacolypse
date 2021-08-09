extends State
# Parent state for all movement-related states
# Holds all of the base movement logic
# Child states can override this states's functions or change its properties
# This keeps the logic grouped in one location

# These should be fallback defaults
# TODO: Make these null and raise an exception to indicate bad State extension
#       to better separate movement vars.
export var max_speed = 10
export var move_speed = 10
export var gravity = -80.0
export var jump_impulse = 35
export (float, 0.1, 20.0, 0.1) var rotation_speed_factor := 10.0

export (int, 0, 200) var inertia = 0

export (int, 2, 100) var wander_range = 25

var velocity := Vector3.ZERO
var input_direction = Vector3.ZERO
var move_direction = Vector3.ZERO

# NavMesh vars
onready var nav = get_tree().current_scene.find_node("Navigation")
var path = []
var path_node = 1

# Debug meshes
var debug_spheres = []


func enter(_msg: Dictionary = {}):
	pass


func physics_process(delta: float):
	var move_direction = Vector3.ZERO
	
	# Move along nav path if it exists
	if path: 
		if path_node < path.size():
			var next_point = path[path_node]
			move_direction = next_point  - _actor.global_transform.origin
			if move_direction.length() < 1:
				path_node += 1
				if debug_spheres[path_node - 1]:
					debug_spheres[path_node - 1].queue_free()
					
			else:
				move_direction = move_direction.normalized()
				move_direction.y = 0
	
	# Rotation
	if move_direction:
		var target_direction = _actor.transform.looking_at(_actor.global_transform.origin + move_direction, Vector3.UP)
		_actor.transform = _actor.transform.interpolate_with(target_direction, rotation_speed_factor * delta)

	# Movement
	velocity = calculate_velocity(velocity, move_direction, delta)
	velocity = _actor.move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, false)


func exit():
	pass


func calculate_velocity(velocity_current: Vector3, move_direction: Vector3, delta: float):
	var velocity_new = move_direction * move_speed
	if velocity_new.length() > max_speed:
		velocity_new = velocity_new.normalized() * max_speed
	velocity_new.y = velocity_current.y + gravity * delta
	
	return velocity_new


func get_random_target_in_range():
	randomize()
	var random_point = Vector3(
		rand_range(2, wander_range), 
		0, 
		rand_range(2, wander_range)
	)
	return nav.get_closest_point(random_point)


func move_to_point(target_position):
	clear_debug_spheres()
	debug_spheres = []
	# Work out a path to the point
	path = nav.get_simple_path(_actor.global_transform.origin, target_position)
	path_node = 1
	for _point in path:
		generate_debug_sphere(_point, 0.25)
	debug_spheres[0].queue_free()


func generate_debug_sphere(target_position, size):
	# Get scene root
	var scene_root = get_tree().root.get_children()[0]
	# Create sphere with low detail of size.
	var sphere = SphereMesh.new()
	sphere.radial_segments = 8
	sphere.rings = 8
	sphere.radius = size
	sphere.height = size * 2
	# Bright red material (unshaded).
	var material = SpatialMaterial.new()
	material.albedo_color = Color(1, 0, 0)
	material.flags_unshaded = true
	sphere.surface_set_material(0, material)
	
	# Add to meshinstance in the right place.
	var node = MeshInstance.new()
	node.mesh = sphere
	node.global_transform.origin = target_position
	scene_root.add_child(node)
	debug_spheres.append(node)


func clear_debug_spheres():
	for node in debug_spheres:
		if is_instance_valid(node):
			node.queue_free()

