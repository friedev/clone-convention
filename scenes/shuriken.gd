class_name Shuriken extends Area2D

@export var speed: float
@export var max_range: float
@export var rotation_speed: float

var thrower: Ninja
var direction: Vector2

@onready var initial_position := self.global_position


func _process(delta: float) -> void:
	self.rotation_degrees += self.rotation_speed * delta


func _physics_process(delta: float) -> void:
	self.global_position += self.direction * self.speed * delta
	if self.global_position.distance_to(self.initial_position) > self.max_range:
		self.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if self.is_queued_for_deletion():
		return
	if body is Ninja:
		var ninja: Ninja = body
		if ninja == self.thrower:
			return
		ninja.die()
	self.queue_free()
