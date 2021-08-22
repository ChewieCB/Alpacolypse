extends Area

export (NodePath) var manager_path
onready var manager = get_node(manager_path)


func _ready():
	manager.connect("arena_restart", self, "reset_arena_trigger")


func reset_arena_trigger():
	for body in get_overlapping_bodies():
		if body is PlayerController:
			manager.start_arena_mode()


func _on_ArenaTrigger_body_entered(body):
	if not body is PlayerController:
		return
	manager.start_arena_mode() 


func _on_ArenaTrigger_body_exited(body):
	if not body is PlayerController:
		return
	manager.arena_mode_cleanup()
	manager.reset_sheep_positions()
