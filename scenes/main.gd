class_name Main extends Node

@export var npc_count: int
@export var world_size: Vector2

@export var ninja_scene: PackedScene


func _ready() -> void:
	SignalBus.node_spawned.connect(self._on_node_spawned)


func new_game() -> void:
	self.spawn_ninja(1)
	self.spawn_ninja(2)
	for i in range(npc_count):
		self.spawn_ninja()


func spawn_ninja(player := 0) -> void:
	var ninja: Ninja = self.ninja_scene.instantiate()
	ninja.player = player
	ninja.position = Vector2(
		randf_range(-0.5, 0.5) * self.world_size.x,
		randf_range(-0.5, 0.5) * self.world_size.y
	)
	self.add_child(ninja)


func _on_node_spawned(node: Node) -> void:
	self.add_child(node)


func _on_main_menu_play_pressed(_previous: Menu) -> void:
	self.new_game()
