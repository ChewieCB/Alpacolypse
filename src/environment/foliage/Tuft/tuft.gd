extends Spatial
class_name GrassTuft


func _init():
	add_to_group("grass_tufts")


#func _ready():
#	yield(owner, "ready")


func _on_Area_body_entered(body):
	if body is Sheep:
		print("")
