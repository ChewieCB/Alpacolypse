extends Area

onready var navigation_node = get_tree().current_scene.find_node("Navigation")

var respawn_navmesh

export (float) var knockback_force = 20.0


func _ready():
	# Hide dev zone meshes in-game
	if not Engine.editor_hint:
		visible = false


func get_closest_navmesh_point(body):
	var body_pos = body.global_transform.origin
	#
	var _closest_navmesh = null
	var _dist_to_closest_nav = Vector3.INF
	var closest_vert = Vector3.INF
	# Walk through all the navmesh verts to find the closest navmesh
	for _navmesh in navigation_node.get_children():
		for _vert in _navmesh.navmesh.get_vertices():
			if body_pos.distance_to(_vert) < body_pos.distance_to(closest_vert):
				closest_vert = _vert
				_closest_navmesh = _navmesh
	
	return closest_vert


func reset_body(body):
	# If the body has a respawn point set, we move it to there
#	if body.respawn_point:
#		body.global_transform.origin = body.respawn_point
#		return
	
	# Otherwise we find the a point on a nearby mesh
	var target_point = get_closest_navmesh_point(body)
	if target_point != Vector3.INF:
		if body is PlayerController:
			body.state_machine.transition_to(
				"Movement/Knockback", 
				{
					"trajectory": body.calcualate_charge_trajectory(
						target_point, 
						knockback_force,
						gravity/2,
						false
					)
				}
					
			)
		else:
			body.global_transform.origin = target_point


func _on_ResetZone_body_entered(body):
	if body is PlayerController:
		reset_body(body)

