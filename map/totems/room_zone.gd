class_name RoomZone
extends Area2D


@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape


func _ready() -> void:
	sprite.position = collision_shape.position
	sprite.scale = (collision_shape.shape as RectangleShape2D).size


func set_enabled(enabled: bool) -> void:
	for body in get_overlapping_bodies():
		if body is Enemy:
			body.set_physics_process(enabled)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		sprite.hide()
		#await get_tree().create_timer(1.0).timeout
		set_enabled(true)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		sprite.show()
		set_enabled(false)
