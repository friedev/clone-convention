class_name Shuriken extends Area2D

@export var speed: float
@export var max_range: float
@export var rotation_speed: float

var thrower: Ninja
var direction: Vector2

@onready var initial_position := global_position


func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	if global_position.distance_to(initial_position) > max_range:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if is_queued_for_deletion():
		return
	if body is Ninja:
		var ninja: Ninja = body
		if ninja == thrower:
			return
		ninja.die()
	queue_free()
