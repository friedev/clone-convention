extends Menu

@export var label: Label


func _ready() -> void:
	self.hide()
	SignalBus.player_died.connect(self._on_player_died)


func _on_menu_button_pressed() -> void:
	self.get_tree().reload_current_scene()


func _on_player_died(player: int) -> void:
	if self.visible:
		return
	self.label.text = "Player %d Wins!" % (3 - player)
	self.open()
