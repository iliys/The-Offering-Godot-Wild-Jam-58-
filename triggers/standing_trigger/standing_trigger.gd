class_name StandingTrigger
extends Area2D


signal toggled(on: bool)

@export var flip_bool := false

var on := false:
	set(value):
		on = value
		sprite.frame = int(on)
		toggled.emit(on != flip_bool)

@onready var sprite: Sprite2D = $Sprite


func _on_body_entered(body: Node2D = null) -> void:
	if get_overlapping_bodies().size() == 1 and not body is Ghost:
		on = true


func _on_body_exited(body: Node2D = null) -> void:
	if get_overlapping_bodies().size() <= 0 and not body is Ghost:
		on = false
