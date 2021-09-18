extends Area

onready var splash_particles_scene = load("res://src/particles/SplashParticles.tscn")
var splash


func _ready():
	# Hide dev zone meshes in-game
	if not Engine.editor_hint:
		visible = false


func _on_DrowningZone_body_entered(body):
	# Generate a splash particles scene at the body's position
	splash = splash_particles_scene.instance()
	body.add_child(splash)
	splash.global_transform.origin = body.global_transform.origin
	splash.global_transform.origin.y += 2
	splash.emitting = true
	
	if body is PlayerController:
		body.state_machine.transition_to("Movement/Drowning")
	else:
		# Call the body's respawn method
		body.respawn()


func _on_DrowningZone_body_exited(_body):
	if splash:
		splash.queue_free()
