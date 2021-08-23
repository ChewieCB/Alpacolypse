extends Area

signal player_entered
signal player_exited

export (NodePath) var manager_path
onready var manager = get_node(manager_path)


func _ready():
	manager.connect("arena_restart", self, "reset_arena_trigger")


func reset_arena_trigger():
	for body in get_overlapping_bodies():
		if body is PlayerController:
			manager.start_arena_mode()


func _on_ArenaTrigger_body_entered(body):
	if body is PlayerController:
		emit_signal("player_entered")


func _on_ArenaTrigger_body_exited(body):
	if body is PlayerController:
		emit_signal("player_exited")

