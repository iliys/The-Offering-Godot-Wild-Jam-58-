class_name Door
extends StaticBody2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape


func set_open(open := true) -> void:
	animated_sprite.play("open" if open else "closed")
	collision_shape.set_deferred("disabled", open)
