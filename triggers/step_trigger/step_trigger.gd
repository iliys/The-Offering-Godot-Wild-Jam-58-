class_name StepTrigger
extends Area2D


signal triggered

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var sprite: Sprite2D = $Sprite


func _on_body_entered(_body: Node2D) -> void:
	collision_shape.set_deferred("disabled", true)
	set_deferred("monitoring", false)
	sprite.frame = 1
	triggered.emit()
