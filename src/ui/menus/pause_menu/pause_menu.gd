extends Control

onready var windowed_button = $CenterContainer/VBoxContainer/OptionsContainer/HBoxContainer/WindowedButton
onready var fullscreen_button = $CenterContainer/VBoxContainer/OptionsContainer/HBoxContainer/FullscreenButton


func _ready():
	# Windowed/fullscreen set
	if GlobalFlags.FULLSCREEN:
		windowed_button.disabled = false
		fullscreen_button.disabled = true
	else:
		windowed_button.disabled = true
		fullscreen_button.disabled = false


func _input(_event):
	if Input.is_action_just_pressed("pause"):
		toggle_pause_menu()


func toggle_pause_menu():
	get_tree().paused = !get_tree().paused
	self.visible = !self.visible
	
	if self.visible and get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_ResumeButton_pressed():
	toggle_pause_menu()


func _on_QuitButton_pressed():
	get_tree().change_scene("res://src/ui/menus/main_menu/MainMenu.tscn")


func _on_WindowedButton_pressed():
	windowed_button.disabled = true
	fullscreen_button.disabled = false
	GlobalFlags.set_FULLSCREEN(false)


func _on_FullscreenButton_pressed():
	windowed_button.disabled = false
	fullscreen_button.disabled = true
	GlobalFlags.set_FULLSCREEN(true)

