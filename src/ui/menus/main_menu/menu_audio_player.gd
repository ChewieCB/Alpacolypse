extends AudioStreamPlayer

export (AudioStreamSample) var cursor_sfx
export (AudioStreamSample) var confirm_sfx
export (AudioStreamSample) var back_sfx
export (AudioStreamSample) var pause_sfx

var suppress_click = false



func cursor():
	# Var to prevent this being fired as a side effect
	if suppress_click:
		return
	self.stream = cursor_sfx
	play()


func confirm():
	self.stream = confirm_sfx
	play()


func back():
	self.stream = back_sfx
	play()


func pause_sfx():
	self.stream = pause_sfx
	play()
