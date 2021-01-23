extends Spatial

onready var level = get_parent()
onready var tuft_scene = load("res://src/environment/foliage/Tuft/Tuft.tscn")

var tufts_to_generate


func _ready():
	randomize()
	tufts_to_generate = int(rand_range(12, 25))
	spawn_grass_tufts()


func _process(_delta):
	var num_grass_tufts = get_child_count()
	if num_grass_tufts == 0:
		spawn_grass_tufts()


func spawn_grass_tufts():
	randomize()
	for tuft in tufts_to_generate:
		var new_tuft = tuft_scene.instance()
		new_tuft.global_transform.origin = Vector3(
			int(rand_range(-45, 45)),
			0,
			int(rand_range(-45, 45))
		)
		add_child(new_tuft)


