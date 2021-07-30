tool
extends Spatial

onready var geometry_objects = get_node("Navigation/LevelGeometry").get_children()


func _process(delta):
	# Set the player position for each shader object
	if geometry_objects:
		for _object in geometry_objects:
			var grass_mesh_name = str(_object.name) + "Grass"
			if _object.has_node(grass_mesh_name):
				var grass_mesh = _object.get_node(grass_mesh_name)
				grass_mesh.material_override.set_shader_param("player_position", $Player.global_transform.origin)

