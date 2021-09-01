extends Spatial

onready var camera = $Camera
onready var llama = $Llama
onready var fadeout = $UI/Fadeout


func _ready():
	fadeout.fade_in()
	llama.transition_to(llama.States.IDLE2)


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
