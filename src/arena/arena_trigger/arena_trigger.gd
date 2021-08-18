extends Area

export (NodePath) var manager_path
onready var manager = get_node(manager_path)


func _on_ArenaTrigger_body_entered(body):
	if not body is PlayerController:
		return
	manager.start_arena_mode() 


func _on_ArenaTrigger_body_exited(body):
	if not body is PlayerController:
		return
	manager.end_arena_mode_fail()
