extends Node

var PLAYER_CONTROLS_ACTIVE = true
var CAMERA_CONTROLS_ACTIVE = true
var CAMERA_INVERT_X = false
var CAMERA_INVERT_Y = true
var SHOW_STATE_LABELS = false
var SHOW_DEBUG_TRAJECTORIES = false

# Settings
var FULLSCREEN = true setget set_FULLSCREEN
var LOOK_SENSITIVITY = 50 setget set_LOOK_SENSITIVITY
var MUSIC_VOLUME = 50 setget set_MUSIC_VOLUME

onready var bgm_player = BGMPlayer


func set_FULLSCREEN(value):
	FULLSCREEN = value
	OS.set_window_fullscreen(FULLSCREEN)


func set_LOOK_SENSITIVITY(value):
	var adjusted_value = range_lerp(value, 0, 100, 0, 30)
	LOOK_SENSITIVITY = adjusted_value


func set_MUSIC_VOLUME(value):
	MUSIC_VOLUME = value
	BGMPlayer.volume_db = linear2db(MUSIC_VOLUME/100)

