extends AudioStreamPlayer

export (AudioStreamSample) var cursor_sfx
export (AudioStreamSample) var confirm_sfx
export (AudioStreamSample) var back_sfx
export (AudioStreamSample) var pause_sfx



func cursor():
	self.stream = cursor_sfx
	play()


func confirm():
	self.stream = confirm_sfx
	play()


func back():
	self.stream = back_sfx
	play()


func pause():
	self.stream = pause_sfx
	play()
