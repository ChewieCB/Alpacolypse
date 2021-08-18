tool
extends Area

export (NodePath) var manager_path
onready var manager = get_node(manager_path)

export (NodePath) var spawn_mesh_path
onready var spawn_mesh = get_node(spawn_mesh_path)


func _ready():
	$UI/SheepCounterUI.global_transform.origin = global_transform.origin + Vector3(0, 5, 0)
	# Generate an array of evenly spaced 2D points to place the sheep at
	var unit_positions = manager.generate_evenly_spaced_points(manager.total_sheep)

	# TODO - abstract this to its own method
	#
	# FIXME - size calc for non-CSG meshes
	var mesh_aabb = spawn_mesh.mesh.get_aabb()
	var mesh_origin = mesh_aabb.position
	var mesh_size = mesh_aabb.size
	#
	# Scale the points to the size of the floor mesh
	var scaled_positions = []
	for _position in unit_positions:
		_position = Vector3(_position.x, 0, _position.y)
		_position *= mesh_size
		_position.y = mesh_origin.y
#		_position *= scale
		scaled_positions.append(_position)
	
	yield(owner, "ready")
	manager.spawn_sheep(mesh_origin, scaled_positions)


func _on_SheepCounterArea_body_entered(body):
	if body is Sheep:
		manager.set_num_current_sheep(get_sheep_count())


func _on_SheepCounterArea_body_exited(body):
	if body is Sheep:
		manager.set_num_current_sheep(get_sheep_count())


func get_sheep_count():
	# Turn environment collision detection off to count sheep already in zone
	var test0 = get_overlapping_bodies()
	var count = get_overlapping_bodies().size()
	return count
	
