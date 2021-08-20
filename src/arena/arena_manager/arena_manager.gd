extends Node

export (NodePath) var arena_ui_path
onready var arena_ui = get_node(arena_ui_path)

export (NodePath) var sacrifice_counter_path
onready var sacrifice_counter = get_node(sacrifice_counter_path)

var timer
var sheep_counter
var popup_message
var popup_visible_timer

export (int) var timer_length = 90    # timer length in seconds


func _ready():
	yield(owner, "ready")
	timer = arena_ui.arena_timer
	sheep_counter = arena_ui.sheep_counter
	popup_message = arena_ui.popup_message
	#
	sacrifice_counter.connect("changed_count", self, "update_counter")
	update_counter()
	#
	timer.connect("timeout", self, "end_arena_mode_fail")
	arena_ui.visible = false
	timer.stop_timer()


func update_counter():
	sheep_counter.sacrificed_label.text = str(sacrifice_counter.num_current_sheep)
	sheep_counter.total_label.text = str(sacrifice_counter.total_sheep)


func start_arena_mode():
	# Show Arena UI
	arena_ui.visible = true
	timer.start_timer(timer_length)
	#
	show_popup("Begin the sacrifice!", 5)


func end_arena_mode_success():
	yield(show_popup("A successful harvest!", 5), "completed")
	arena_mode_cleanup()


func end_arena_mode_fail():
	yield(show_popup("A pitiful harvest!", 5), "completed")
	arena_mode_cleanup()


func arena_mode_cleanup():
	timer.stop_timer()
	# TODO - add animation to flash final time before disappearing
	#
	# Hide Arena UI
	arena_ui.visible = false
	#
	reset_sheep_positions()


func show_popup(message, time):
	yield(get_tree(), "idle_frame")
	popup_message.label.text = str(message)
	popup_message.visible = true
	# 
	popup_visible_timer = Timer.new()
	popup_visible_timer.wait_time = time
	popup_visible_timer.connect("timeout", self, "hide_popup")
	add_child(popup_visible_timer)
	#
	popup_visible_timer.start()
	
	# Return a bool here so we can yield this method
	return true


func hide_popup():
	yield(get_tree(), "idle_frame")
	popup_message.visible = false
	popup_message.label.text = ""
	#
	popup_visible_timer.queue_free()
	
	return true


func reset_sheep_positions():
	pass

