extends Spatial

onready var camera = $Camera
onready var llama = $Llama
onready var fadeout = $UI/Fadeout
onready var audio_player = $MenuAudioPlayer
onready var animation_player = $AnimationPlayer

# Main
onready var play_button = $UI/Control/VBoxContainer2/MainScreen/VBoxContainer/PlayContainer/PlayButton
onready var options_button = $UI/Control/VBoxContainer2/MainScreen/VBoxContainer/OptionsContainer/OptionsButton
onready var quit_button = $UI/Control/VBoxContainer2/MainScreen/VBoxContainer/QuitContainer/QuitButton
# Options
onready var windowed_button = $UI/Control/VBoxContainer2/OptionsScreen/VBoxContainer/DisplayContainer/HBoxContainer/WindowedButton
onready var fullscreen_button = $UI/Control/VBoxContainer2/OptionsScreen/VBoxContainer/DisplayContainer/HBoxContainer/FullscreenButton
onready var look_sensitivity_slider = $UI/Control/VBoxContainer2/OptionsScreen/VBoxContainer/LookSensitivityContainer/HBoxContainer/HBoxContainer/CenterContainer/LookSensitivitySlider
onready var look_sensitivity_label = $UI/Control/VBoxContainer2/OptionsScreen/VBoxContainer/LookSensitivityContainer/HBoxContainer/HBoxContainer/CenterContainer2/SliderLabel
onready var music_volume_slider = $UI/Control/VBoxContainer2/OptionsScreen/VBoxContainer/MusicVolumeContainer/HBoxContainer/HBoxContainer/CenterContainer/MusicVolumeSlider
onready var music_volume_label = $UI/Control/VBoxContainer2/OptionsScreen/VBoxContainer/MusicVolumeContainer/HBoxContainer/HBoxContainer/CenterContainer2/SliderLabel
onready var back_button = $UI/Control/VBoxContainer2/OptionsScreen/VBoxContainer/BackContainer/BackButton

onready var buttons = [
	play_button, options_button, quit_button,
	windowed_button, fullscreen_button,
	look_sensitivity_slider, music_volume_slider,
	back_button
]

var active_slider = null


func _ready():
	get_tree().paused = false
	fadeout.fade_in()
	llama.transition_to(llama.States.IDLE2)
	
	look_sensitivity_slider.value = GlobalFlags.LOOK_SENSITIVITY
	look_sensitivity_label.text = str(look_sensitivity_slider.value)
	music_volume_slider.value = GlobalFlags.MUSIC_VOLUME
	music_volume_label.text = str(music_volume_slider.value)
	
	# Set all buttons to have an initial focus mode of FOCUS_ALL
	play_button.focus_mode = 2
	options_button.focus_mode = 2
	quit_button.focus_mode = 2
	look_sensitivity_slider.focus_mode = 2
	music_volume_slider.focus_mode = 2
	
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
		
		if play_button.visible:
			play_button.grab_focus()
		elif back_button.visible:
			back_button.grab_focus()
	else:
		if active_slider:
			if Input.is_action_pressed("ui_left"):
				active_slider.value -= 1
			elif Input.is_action_pressed("ui_right"):
				active_slider.value += 1


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


func get_options_menu_focus():
	# Windowed/fullscreen set
	if GlobalFlags.FULLSCREEN:
		windowed_button.grab_focus()
	else:
		fullscreen_button.grab_focus()


func lose_options_menu_focus():
	options_button.grab_focus()


func transition_to_game():
	yield(fadeout.fade_out(), "completed")
	get_tree().change_scene("res://src/levels/tl_mvp_04/TL_04.tscn")


func _on_PlayButton_pressed():
	llama.transition_to(llama.States.BONK)
	audio_player.confirm()
	transition_to_game()


func _on_OptionsButton_pressed():
	animation_player.play("main_to_options_transition")
	yield(animation_player, "animation_finished")


func _on_QuitButton_pressed():
	llama.transition_to(llama.States.BONK)
#	yield(llama.animation_player, "animation_changed")
	audio_player.back()
	yield(fadeout.fade_out(), "completed")
	get_tree().quit()


# OPTIONS MENU

func _on_WindowedButton_pressed():
	windowed_button.disabled = true
	fullscreen_button.disabled = false
	GlobalFlags.set_FULLSCREEN(false)

	# For windowed/fullscreen we disable focus on whichever is active
	windowed_button.focus_mode = 0
	fullscreen_button.focus_mode = 2
	# Grab focus of the active button so we don't lose focus
	fullscreen_button.grab_focus()


func _on_FullscreenButton_pressed():
	windowed_button.disabled = false
	fullscreen_button.disabled = true
	GlobalFlags.set_FULLSCREEN(true)

	# For windowed/fullscreen we disable focus on whichever is active
	windowed_button.focus_mode = 2
	fullscreen_button.focus_mode = 0
	# Grab focus of the active button so we don't lose focus
	windowed_button.grab_focus()


func _on_BackButton_pressed():
	animation_player.play("options_to_main_transition")
	yield(animation_player, "animation_finished")


func _on_LookSensitivitySlider_value_changed(value):
	# Update label value
	look_sensitivity_label.text = str(look_sensitivity_slider.value)
	GlobalFlags.set_LOOK_SENSITIVITY(value)


func _on_LookSensitivitySlider_focus_entered():
	active_slider = look_sensitivity_slider


func _on_LookSensitivitySlider_focus_exited():
	active_slider = null


func _on_MusicVolumeSlider_value_changed(value):
	music_volume_label.text = str(music_volume_slider.value)
	GlobalFlags.set_MUSIC_VOLUME(value)


func _on_MusicVolumeSlider_focus_entered():
	active_slider = music_volume_slider


func _on_MusicVolumeSlider_focus_exited():
	active_slider = null

