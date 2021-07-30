extends Spatial
class_name GrassTuft


func _init():
	add_to_group("grass_tufts")


func _ready():
	# Randomly pick one of 2 meshes
	randomize()
	if randf() > 0.5:
		$Mesh2.queue_free()
	else:
		$Mesh1.queue_free()
	#
	var scale_factor = rand_range(0.8, 1.5)
	scale = Vector3(scale_factor, scale_factor, scale_factor)
	


func _on_Area_body_entered(body):
	if body is Sheep:
		print("")
