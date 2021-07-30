tool
extends MeshInstance


func _process(delta):
	var grass_material = get_parent().get_node("MultiMeshInstance").material_override
	grass_material.set_shader_param(
		"player_position", global_transform.origin
		)
