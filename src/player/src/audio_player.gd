extends Node

signal transitioned

export (AudioStreamSample) var walk_sfx
export (AudioStreamSample) var charge_sfx
export (AudioStreamSample) var jump_sfx
export (AudioStreamSample) var land_sfx
export (AudioStreamSample) var bonk_sfx
export (AudioStreamSample) var fall_sfx
export (AudioStreamSample) var drown_sfx

enum States { WALK, CHARGE, JUMP, LAND, BONK, FALL, DROWN }

onready var audio_player = $AudioStreamPlayer3D


func play_audio(state):
	match state:
		States.WALK:
			audio_player.stream = walk_sfx
		States.CHARGE:
			audio_player.stream = charge_sfx
		States.JUMP:
			audio_player.stream = jump_sfx
		States.LAND:
			audio_player.stream = land_sfx
		States.BONK:
			audio_player.stream = bonk_sfx
		States.FALL:
			audio_player.stream = fall_sfx
		States.DROWN:
			audio_player.stream = drown_sfx
	
	if audio_player.stream:
		audio_player.play()


func stop_audio():
	audio_player.stop()
	audio_player.stream = null


func transition_to(state):
	stop_audio()
	play_audio(state)
	emit_signal("transitioned", state)
