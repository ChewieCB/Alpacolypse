extends Node

signal arena_restart

export (NodePath) var arena_ui_path
onready var arena_ui = get_node(arena_ui_path)

export (NodePath) var arena_zone_path
onready var arena_zone = get_node(arena_zone_path)

export (NodePath) var counter_manager_path
onready var counter_manager = get_node(counter_manager_path)

onready var popup_visible_timer = $PopupVisibleTimer

var countdown_timer
var sheep_counter
var popup_message

export (int) var timer_length = 90    # timer length in seconds


func _ready():
	yield(owner, "ready")
	# Set UI vars
	countdown_timer = arena_ui.arena_timer
	sheep_counter = arena_ui.sheep_counter
	popup_message = arena_ui.popup_message
	# Counters
	counter_manager.connect("count_changed", self, "update_counter")
	counter_manager.connect("count_full", self, "end_arena_mode_success")
	update_counter(counter_manager.total_count)
	# Arena Zone Trigger
	arena_zone.connect("player_entered", self, "start_arena_mode")
	arena_zone.connect("player_exited", self, "exit_arena_mode")
	# Timer UI
	countdown_timer.connect("timeout", self, "countdown_timer_timeout")
	popup_visible_timer.connect("timeout", self, "hide_popup")
	arena_ui.visible = false
	countdown_timer.stop_timer()


func update_counter(_value):
	sheep_counter.sacrificed_label.text = str(counter_manager.combined_current_count)
	sheep_counter.total_label.text = str(counter_manager.total_count)


func start_arena_mode():
	# Show Arena UI
	arena_ui.visible = true
	countdown_timer.timer.set_paused(false)
	countdown_timer.start_timer(timer_length)
	counter_manager.reset_count()
	
	yield(show_popup("Begin the sacrifice!", 3), "completed")


func exit_arena_mode():
	countdown_timer.timer.set_paused(true)
	yield(show_popup("A shameful retreat!", 3), "completed")
	arena_mode_cleanup()
	reset_sheep_positions()


func countdown_timer_timeout():
	if counter_manager.combined_current_count < counter_manager.total_count:
		end_arena_mode_fail()
	else:
		end_arena_mode_success(null)


func end_arena_mode_success(_count):
	countdown_timer.timer.set_paused(true)
	yield(show_popup("A bountiful harvest!", 3), "completed")
	arena_mode_cleanup()


func end_arena_mode_fail():
	countdown_timer.timer.set_paused(true)
	yield(show_popup("A pitiful harvest!", 3), "completed")
	arena_mode_cleanup()
	reset_sheep_positions()
	emit_signal("arena_restart")


func arena_mode_cleanup():
	countdown_timer.stop_timer()
	counter_manager.reset_count()
	# TODO - add animation to flash final time before disappearing
	#
	# Hide Arena UI
	arena_ui.visible = false


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
	counter_manager.reset_sheep()

