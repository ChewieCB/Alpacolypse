extends Spatial

onready var camera = $Camera
onready var llama = $Llama
onready var fadeout = $UI/Fadeout

onready var windowed_button = $UI/Control/VBoxContainer2/HBoxContainer/VBoxContainer/CenterContainer2/HBoxContainer/WindowedButton
onready var fullscreen_button = $UI/Control/VBoxContainer2/HBoxContainer/VBoxContainer/CenterContainer2/HBoxContainer/FullscreenButton


func _ready():
	get_tree().paused = false
	fadeout.fade_in()
	llama.transition_to(llama.States.IDLE2)
	
	# Windowed/fullscreen set
	if GlobalFlags.FULLSCREEN:
		windowed_button.disabled = false
		fullscreen_button.disabled = true
	else:
		windowed_button.disabled = true
		fullscreen_button.disabled = false


func transition_to_game():
	yield(fadeout.fade_out(), "completed")
	get_tree().change_scene("res://src/levels/tl_mvp_04/TL_04.tscn")


func _on_PlayButton_pressed():
	llama.transition_to(llama.States.BONK)
	transition_to_game()


func _on_QuitButton_pressed():
	llama.transition_to(llama.States.BONK)
#	yield(llama.animation_player, "animation_changed")
	yield(fadeout.fade_out(), "completed")
	get_tree().quit()


func _on_WindowedButton_pressed():
	windowed_button.disabled = true
	fullscreen_button.disabled = false
	GlobalFlags.set_FULLSCREEN(false)


func _on_FullscreenButton_pressed():
	windowed_button.disabled = false
	fullscreen_button.disabled = true
	GlobalFlags.set_FULLSCREEN(true)


