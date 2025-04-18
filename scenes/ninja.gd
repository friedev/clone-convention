class_name Ninja extends CharacterBody2D

const DIRECTIONS: Array[Vector2] = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN,
]


@export var speed: float
@export var shuriken_cooldown: float

@export var min_move_delay: float
@export var max_move_delay: float

@export var shuriken_scene: PackedScene
@export var corpse_scene: PackedScene

var shuriken_ready := true
var player: int
var last_direction := Vector2.RIGHT
var direction: Vector2:
	set(value):
		direction = value
		self.velocity = self.direction.normalized() * self.speed
		if self.direction != Vector2.ZERO:
			self.last_direction = self.direction


func is_player() -> bool:
	return self.player != 0


func _ready() -> void:
	while not self.is_player():
		var weight := randf() # ** 2.0
		var delay := lerpf(self.min_move_delay, self.max_move_delay, weight)
		await get_tree().create_timer(delay, false, true).timeout
		self.change_direction()


func _physics_process(_delta: float) -> void:
	if self.is_player():
		self.direction = Input.get_vector(
			"move_left_p%d" % self.player,
			"move_right_p%d" % self.player,
			"move_up_p%d" % self.player,
			"move_down_p%d" % self.player
		)
	var prev_velocity := self.velocity
	self.move_and_slide()
	if self.velocity != prev_velocity:
		self.direction = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if self.is_player():
		if event.is_action_pressed("shoot_p%d" % self.player):
			if self.shuriken_ready:
				var shuriken: Shuriken = self.shuriken_scene.instantiate()
				shuriken.global_position = self.global_position
				shuriken.direction = self.last_direction
				shuriken.thrower = self
				SignalBus.node_spawned.emit(shuriken)

				self.shuriken_ready = false
				await self.get_tree().create_timer(self.shuriken_cooldown).timeout
				self.shuriken_ready = true


func change_direction() -> void:
	if self.direction == Vector2.ZERO:
		while self.direction == Vector2.ZERO or self.test_move(self.global_transform, self.velocity):
			self.direction = DIRECTIONS.pick_random()
	else:
		self.direction = Vector2.ZERO


func die() -> void:
	if self.is_player():
		SignalBus.player_died.emit(self.player)
	var corpse: Node2D = self.corpse_scene.instantiate()
	corpse.global_position = self.global_position
	SignalBus.node_spawned.emit(corpse)
	self.queue_free()
