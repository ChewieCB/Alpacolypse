extends Control


onready var arena_timer = $MarginContainer/VBoxContainer/TopHBox/ArenaTimer
onready var sheep_counter = $MarginContainer/VBoxContainer/TopHBox/ArenaSheepCounter
onready var popup_message = $MarginContainer/VBoxContainer/ArenaPopupMessage


func _ready():
	yield(owner, "ready")
