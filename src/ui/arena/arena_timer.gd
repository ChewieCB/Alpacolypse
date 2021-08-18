extends Control

signal timeout

onready var timer = $Timer
onready var label = $CenterContainer/Label


func _process(_delta):
	label.text = convert_seconds_to_clock(timer.time_left)


func start_timer(time):
	timer.wait_time = time
	timer.start()


func stop_timer():
	timer.stop()


func convert_seconds_to_clock(raw_seconds):
	var _seconds_total = int(raw_seconds)
	var _minutes = int(_seconds_total / 60)
	var _seconds = _seconds_total - (60 * _minutes)
	var output_string = "%02d:%02d" % [_minutes, _seconds]
	
	return output_string


func _on_Timer_timeout():
	emit_signal("timeout")

