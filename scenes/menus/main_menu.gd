extends Menu

signal play_pressed(previous: Menu)
signal how_to_play_pressed(previous: Menu)
signal credits_pressed(previous: Menu)


func _ready() -> void:
	self.open()


func open(_previous: Menu = null) -> void:
	super.open()


func _on_play_button_pressed() -> void:
	self.close()
	self.play_pressed.emit(self)


func _on_how_to_play_button_pressed() -> void:
	self.hide()
	self.how_to_play_pressed.emit(self)


func _on_credits_button_pressed() -> void:
	self.hide()
	self.credits_pressed.emit(self)


func _on_quit_button_pressed() -> void:
	self.get_tree().quit()
