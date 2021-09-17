extends Spatial

signal transitioned

export (AudioStreamSample) var idle_sfx
export (AudioStreamSample) var walk_sfx
export (AudioStreamSample) var run_sfx
export (AudioStreamSample) var jump_sfx
export (AudioStreamSample) var land_sfx
export (Array, AudioStreamSample) var bleat_sfx_array
export (AudioStreamSample) var fall_sfx
export (AudioStreamSample) var drown_sfx
export (AudioStreamSample) var respawn_sfx

enum States { IDLE, WALK, RUN, JUMP, LAND, FLUNG, FALL, DROWN, RESPAWN }

onready var audio_player = $AudioStreamPlayer3D


func play_audio(state):
	match state:
		States.IDLE:
			audio_player.stream = idle_sfx
		States.WALK:
			audio_player.stream = walk_sfx
		States.RUN:
			audio_player.stream = run_sfx
		States.JUMP:
			audio_player.stream = jump_sfx
		States.LAND:
			audio_player.stream = land_sfx
		States.FLUNG:
			audio_player.stream = get_bleat_sfx()
		States.FALL:
			audio_player.stream = fall_sfx
		States.DROWN:
			randomize()
			audio_player.pitch_scale = rand_range(0.8, 1.2)
			audio_player.unit_db = 4
			audio_player.unit_size = 6
			audio_player.stream = drown_sfx
		States.RESPAWN:
			audio_player.stream = respawn_sfx
	
	if audio_player.stream:
		audio_player.play()


func stop_audio():
	audio_player.stop()
	audio_player.stream = null
	audio_player.pitch_scale = 1
	audio_player.unit_db = 1
	audio_player.unit_size = 3


func transition_to(state):
	stop_audio()
	play_audio(state)
	emit_signal("transitioned", state)


func get_bleat_sfx():
	# Get a random bleat sfx from the array
	randomize()
	audio_player.pitch_scale = rand_range(0.8, 1.2)
	var random_sample = bleat_sfx_array[randi() % bleat_sfx_array.size()]
	print(random_sample)
	return random_sample

