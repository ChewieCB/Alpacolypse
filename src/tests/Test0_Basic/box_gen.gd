extends Node

onready var level = get_parent()
onready var no_go_zone = level.get_node("PIT/PlayerBlocker")
onready var box_scene = load("res://src/tests/test_objects/Box.tscn")

var boxes_to_generate


func _ready():
	randomize()
	boxes_to_generate = int(rand_range(5, 14))
	generate_boxes()


func _process(_delta):
	if get_child_count() == 0:
		randomize()
		boxes_to_generate = int(rand_range(6, 15))
		generate_boxes()


func generate_boxes():
	randomize()
	for box in boxes_to_generate:
		var new_box = box_scene.instance()
		# Don't generate over the pit
		new_box.global_transform.origin = Vector3(
				int(rand_range(-40, 40)),
				int(rand_range(25, 40)),
				int(rand_range(-40, 40))
		)
		while new_box.global_transform.origin.distance_to(no_go_zone.global_transform.origin) < no_go_zone.shape.radius:
			new_box.global_transform.origin = Vector3(
				int(rand_range(-40, 40)),
				int(rand_range(25, 40)),
				int(rand_range(-40, 40))
			)
		add_child(new_box)
