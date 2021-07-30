extends Area


func _on_BodyFrier_body_entered(body):
	if body is RigidBody:
		body.queue_free()
	elif body is Sheep:
		body.state_machine.state.exit()
		body.queue_free()
	else:
		# TODO - use an impulse to fling the player back out if they somehow 
		# manage to get in the pit.
		pass


func _on_GravityWell_body_entered(body):
	if body is RigidBody:
		body.gravity_scale = 6 
