extends State
# State for when there is no movement input
# Supports triggering jump after the Sheep has started to fall

var idle_timer = null
var skin
var audio_player


func enter(_msg: Dictionary = {}):
	audio_player = _actor.audio_player
	skin = _actor.skin
	_parent.velocity = Vector3.ZERO
	_parent.path = null
	_parent.enter()
	
	skin.transition_to(skin.States.IDLE)
	
	idle_timer = Timer.new()
	idle_timer.wait_time = rand_range(1.5, 5.0)
	idle_timer.connect("timeout", self, "_on_idle_timer_timeout")
	add_child(idle_timer)
	idle_timer.start()
	if audio_player.audio_player.playing:
		yield(audio_player.audio_player, "finished")
		audio_player.stop_audio()


func physics_process(delta: float):
	_parent.physics_process(delta)


func exit():
	idle_timer.queue_free()
	_parent.exit()


func _on_idle_timer_timeout():
	idle_timer.queue_free()
	_state_machine.transition_to("Movement/Walking")

