extends Area


func _ready():
	# Hide dev zone meshes in-game
	if not Engine.editor_hint:
		visible = false


func _on_DrowningZone_body_entered(body):
	if body is PlayerController:
		body.state_machine.transition_to("Movement/Drowning")
	else:
		# Call the body's respawn method
		body.respawn()
