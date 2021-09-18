extends AudioStreamPlayer

export (AudioStreamSample) var enter_area_sfx
export (AudioStreamSample) var exit_area_sfx


func enter_area():
	self.stream = enter_area_sfx
	play()


func exit_area():
	self.stream = exit_area_sfx
	play()

