class_name Ninja
extends CharacterBody2D

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
		velocity = direction.normalized() * speed
		if direction != Vector2.ZERO:
			last_direction = direction


func is_player() -> bool:
	return player != 0


func _ready() -> void:
	while not is_player():
		var weight := randf() # ** 2.0
		var delay := lerpf(min_move_delay, max_move_delay, weight)
		await get_tree().create_timer(delay, false, true).timeout
		change_direction()


func _physics_process(_delta: float) -> void:
	if is_player():
		direction = Input.get_vector(
			"move_left_p%d" % player,
			"move_right_p%d" % player,
			"move_up_p%d" % player,
			"move_down_p%d" % player,
		)
	var prev_velocity := velocity
	move_and_slide()
	if velocity != prev_velocity:
		direction = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if is_player():
		if event.is_action_pressed("shoot_p%d" % player):
			if shuriken_ready:
				var shuriken: Shuriken = shuriken_scene.instantiate()
				shuriken.global_position = global_position
				shuriken.direction = last_direction
				shuriken.thrower = self
				SignalBus.node_spawned.emit(shuriken)

				shuriken_ready = false
				await get_tree().create_timer(shuriken_cooldown).timeout
				shuriken_ready = true


func change_direction() -> void:
	if direction == Vector2.ZERO:
		while direction == Vector2.ZERO or test_move(global_transform, velocity):
			direction = DIRECTIONS.pick_random()
	else:
		direction = Vector2.ZERO


func die() -> void:
	if is_player():
		SignalBus.player_died.emit(player)
	var corpse: Node2D = corpse_scene.instantiate()
	corpse.global_position = global_position
	SignalBus.node_spawned.emit(corpse)
	queue_free()
