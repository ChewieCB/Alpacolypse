extends State
# State for when there is no movement input
# Supports triggering jump after the Sheep has started to fall

var idle_timer = null


func enter(_msg: Dictionary = {}):
	_parent.velocity = Vector3.ZERO
	_parent.path = null
	_parent.enter()
	
	idle_timer = Timer.new()
	idle_timer.wait_time = rand_range(1.5, 5.0)
	idle_timer.connect("timeout", self, "_on_idle_timer_timeout")
	add_child(idle_timer)
	idle_timer.start()


func physics_process(delta: float):
	_parent.physics_process(delta)


func exit():
	_parent.exit()


func _on_idle_timer_timeout():
	idle_timer.queue_free()
	_state_machine.transition_to("Movement/Walking")

