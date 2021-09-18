extends Spatial

onready var camera = $Camera
onready var llama = $Llama
onready var fadeout = $UI/Fadeout
onready var audio_player = $MenuAudioPlayer

onready var play_button = $UI/Control/VBoxContainer2/HBoxContainer/VBoxContainer/CenterContainer/PlayButton
onready var windowed_button = $UI/Control/VBoxContainer2/HBoxContainer/VBoxContainer/CenterContainer2/HBoxContainer/WindowedButton
onready var fullscreen_button = $UI/Control/VBoxContainer2/HBoxContainer/VBoxContainer/CenterContainer2/HBoxContainer/FullscreenButton
onready var quit_button = $UI/Control/VBoxContainer2/HBoxContainer/VBoxContainer/CenterContainer3/QuitButton
onready var buttons = [play_button, windowed_button, fullscreen_button, quit_button]


func _ready():
	get_tree().paused = false
	fadeout.fade_in()
	llama.transition_to(llama.States.IDLE2)
	
	# Set all buttons to have an initial focus mode of FOCUS_ALL
	play_button.focus_mode = 2
	quit_button.focus_mode = 2
	
	# Windowed/fullscreen set
	if GlobalFlags.FULLSCREEN:
		windowed_button.disabled = false
		fullscreen_button.disabled = true
		# For windowed/fullscreen we disable focus on whichever is active
		windowed_button.focus_mode = 2
		fullscreen_button.focus_mode = 0
	else:
		windowed_button.disabled = true
		fullscreen_button.disabled = false
		# For windowed/fullscreen we disable focus on whichever is active
		windowed_button.focus_mode = 0
		fullscreen_button.focus_mode = 2
	
	Input.connect("joy_connection_changed", self, "controller_ui_focus")
	
	# Connect the focus_enter signal for each button to the sfx player
	for _button in buttons:
		_button.connect("focus_entered", audio_player, "cursor")


func _input(_event):
	if Input.is_action_just_released("ui_down") or \
	Input.is_action_just_released("ui_up"):
		# We only want this to grab focus on the FIRST pressing when 
		# no buttons have focus, so if any buttons currently have focus, exit.
		for _button in buttons:
			if _button.has_focus():
				return
		
		play_button.grab_focus()


func controller_ui_focus(device, connected):
	var has_focus = false
	var button_with_focus
	
	# Determine if we already have focus
	for _button in buttons:
		if _button.has_focus():
			has_focus = true
			button_with_focus = _button
			break
	
	if connected and not has_focus:
		play_button.grab_focus()
	elif not connected and has_focus:
		button_with_focus.release_focus()


func transition_to_game():
	yield(fadeout.fade_out(), "completed")
	get_tree().change_scene("res://src/levels/tl_mvp_04/TL_04.tscn")


func _on_PlayButton_pressed():
	llama.transition_to(llama.States.BONK)
	audio_player.confirm()
	transition_to_game()


func _on_QuitButton_pressed():
	llama.transition_to(llama.States.BONK)
#	yield(llama.animation_player, "animation_changed")
	audio_player.back()
	yield(fadeout.fade_out(), "completed")
	get_tree().quit()


func _on_WindowedButton_pressed():
	windowed_button.disabled = true
	fullscreen_button.disabled = false
	GlobalFlags.set_FULLSCREEN(false)
	
	audio_player.cursor()
	# For windowed/fullscreen we disable focus on whichever is active
	windowed_button.focus_mode = 0
	fullscreen_button.focus_mode = 2
	# Grab focus of the active button so we don't lose focus
	fullscreen_button.grab_focus()


func _on_FullscreenButton_pressed():
	windowed_button.disabled = false
	fullscreen_button.disabled = true
	GlobalFlags.set_FULLSCREEN(true)
	
	audio_player.cursor()
	# For windowed/fullscreen we disable focus on whichever is active
	windowed_button.focus_mode = 2
	fullscreen_button.focus_mode = 0
	# Grab focus of the active button so we don't lose focus
	windowed_button.grab_focus()
