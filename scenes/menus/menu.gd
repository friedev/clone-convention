class_name Menu extends Control

signal opened
signal closed

@export var default_focus: Control
@export var can_go_back := true

var previous: Menu


func _ready() -> void:
	hide()


func open(previous: Menu = null) -> void:
	if visible:
		return
	previous = previous
	show()
	if default_focus != null:
		default_focus.grab_focus()
	Globals.is_menu_open = true
	opened.emit()


func close() -> void:
	if not visible:
		return
	hide()
	if can_go_back and previous != null:
		previous.open()
	else:
		Globals.is_menu_open = false
	closed.emit()


func _input(event: InputEvent) -> void:
	if (
		can_go_back
		and visible
		and event.is_action_pressed(&"ui_cancel")
	):
		close()
