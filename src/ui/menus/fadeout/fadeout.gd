extends Control

onready var anim_player = $AnimationPlayer


func fade_out():
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")


func fade_out_reset():
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")
	get_tree().reload_current_scene()


func fade_in():
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")

