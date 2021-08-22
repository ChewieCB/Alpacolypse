extends Node

signal arena_restart

export (NodePath) var arena_ui_path
onready var arena_ui = get_node(arena_ui_path)

export (NodePath) var sacrifice_counter_path
onready var sacrifice_counter = get_node(sacrifice_counter_path)

onready var popup_visible_timer = $PopupVisibleTimer

var countdown_timer
var sheep_counter
var popup_message

export (int) var timer_length = 90    # timer length in seconds


func _ready():
	yield(owner, "ready")
	countdown_timer = arena_ui.arena_timer
	sheep_counter = arena_ui.sheep_counter
	popup_message = arena_ui.popup_message
	#
	sacrifice_counter.connect("changed_count", self, "update_counter")
	sacrifice_counter.connect("pit_full", self, "end_arena_mode_success")
	#
	countdown_timer.connect("timeout", self, "countdown_timer_timeout")
	popup_visible_timer.connect("timeout", self, "hide_popup")
	#
	arena_ui.visible = false
	countdown_timer.stop_timer()
	#
	update_counter()


func update_counter():
	sheep_counter.sacrificed_label.text = str(sacrifice_counter.num_current_sheep)
	sheep_counter.total_label.text = str(sacrifice_counter.total_sheep)


func start_arena_mode():
	# Show Arena UI
	arena_ui.visible = true
	countdown_timer.timer.set_paused(false)
	countdown_timer.start_timer(timer_length)
	#
	show_popup("Begin the sacrifice!", 5)


func countdown_timer_timeout():
	if sacrifice_counter.num_current_sheep < sacrifice_counter.total_sheep:
		end_arena_mode_fail()
	else:
		end_arena_mode_success()


func end_arena_mode_success():
	countdown_timer.timer.set_paused(true)
	yield(show_popup("A successful harvest!", 5), "completed")
	arena_mode_cleanup()


func end_arena_mode_fail():
	countdown_timer.timer.set_paused(true)
	yield(show_popup("A pitiful harvest!", 5), "completed")
	arena_mode_cleanup()
	sacrifice_counter.reset_sheep()
	emit_signal("arena_restart")


func arena_mode_cleanup():
	countdown_timer.stop_timer()
	# TODO - add animation to flash final time before disappearing
	#
	# Hide Arena UI
	arena_ui.visible = false
	# Reset the sacrificial arena
	reset_sheep_positions()


func show_popup(message, time):
	yield(get_tree(), "idle_frame")
#	arena_ui.visible = true
	popup_message.label.text = str(message)
	popup_message.visible = true
	# 
	popup_visible_timer.wait_time = time
	popup_visible_timer.start()
	
	yield(popup_visible_timer, "timeout")
	# Return a bool here so we can yield this method
	return true


func hide_popup():
	yield(get_tree(), "idle_frame")
	popup_message.visible = false
	popup_message.label.text = ""
	#
	popup_visible_timer.stop()
	
	return true


func reset_sheep_positions():
	sacrifice_counter.reset_sheep()

