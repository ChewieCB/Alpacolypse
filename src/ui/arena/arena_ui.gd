extends Control


onready var arena_timer = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer2/ArenaTimer
onready var sheep_counter = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer3/ArenaSheepCounter
onready var popup_message = $MarginContainer/VBoxContainer/Padding/ArenaPopupMessage


func _ready():
	yield(owner, "ready")
