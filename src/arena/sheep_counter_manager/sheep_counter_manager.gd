extends Node


export (int) var total_sheep
var num_current_sheep setget set_num_current_sheep, get_num_current_sheep

export (NodePath) var counter_ui_path
onready var counter_ui = get_node(counter_ui_path)

export (NodePath) var sheep_parent_node_path
onready var sheep_parent_node = get_node(sheep_parent_node_path)

onready var sheep_scene = preload("res://src/characters/sheep/src/Sheep.tscn")


func _ready():
	get_num_current_sheep()


func all_sheep_in_area():
	# Emit a signal that can trigger other objects like pillars, doors, buttons, etc.
	pass


func spawn_sheep(mesh_origin, scaled_position_array):
	#
	for point in scaled_position_array:
		var sheep_instance = sheep_scene.instance()
		sheep_instance.global_transform.origin = mesh_origin + point
		sheep_parent_node.add_child(sheep_instance)


func set_num_current_sheep(value):
	num_current_sheep = value
	# Update UI
	counter_ui.label.text = " %s / %s" % [num_current_sheep, total_sheep]


func get_num_current_sheep():
	return num_current_sheep


func generate_evenly_spaced_points(number_of_points):
	# Taken from an algorithm outlined in this SO post
	# https://math.stackexchange.com/questions/2186861/how-can-we-effectively-generate-a-set-of-evenly-spaced-points-in-a-2d-region
	#
	# Keep this at 2D for now to stop it getting complicated, I barely
	# understand this algorithm as it is.
	var dimensions = 2
	var gamma = _gamma(dimensions)
	# 
	var alpha = Vector2(
		fmod(pow(1/gamma, 2), 1),
		fmod(pow(1/gamma, 3), 1)
	)
	
	# Create the output array
	var output_array = []
	for i in range(number_of_points):
		# Break this down into components for code legibility
		var alpha_component = alpha * (i+1)
		var offset = Vector2(0.5, 0.5)
		var new_point = alpha_component + offset
		# Apply the fmod to each dimension of the vector
		new_point.x = fmod(new_point.x, 1)
		new_point.y = fmod(new_point.y, 1)

		output_array.append(new_point)
	
	# NOTE: These points are unit-length so will have to be multiplied by the
	# size of the area for a better spread.
	return output_array


func _gamma(d):
	var x = 1.0000
	for i in range(20):
		x = x - (pow(x, d+1) - x - 1) / ((d+1) * pow(x, d) - 1)
	return x

