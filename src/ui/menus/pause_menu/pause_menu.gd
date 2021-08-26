extends Control



func _input(_event):
	if Input.is_action_just_pressed("pause"):
		toggle_pause_menu()


func toggle_pause_menu():
	get_tree().paused = !get_tree().paused
	self.visible = !self.visible
	
	if self.visible and get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_ResumeButton_pressed():
	toggle_pause_menu()


func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
	# TODO - make this go back to main menu
