extends Menu


func _ready() -> void:
	self.hide()


func open(_previous: Menu = null) -> void:
	self.get_tree().paused = true
	super.open(previous)


func close() -> void:
	self.get_tree().paused = false
	super.close()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if not Globals.is_menu_open:
			self.open()
			return
	super._input(event)


func _on_menu_button_pressed() -> void:
	self.get_tree().reload_current_scene()
