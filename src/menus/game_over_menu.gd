extends Menu

@export var label: Label


func _ready() -> void:
	hide()
	SignalBus.player_died.connect(_on_player_died)


func _on_menu_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_player_died(player: int) -> void:
	if visible:
		return
	label.text = "Player %d Wins!" % (3 - player)
	open()
