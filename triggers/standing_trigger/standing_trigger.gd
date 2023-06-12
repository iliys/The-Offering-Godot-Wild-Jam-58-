class_name StandingTrigger
extends Area2D


signal toggled(on: bool)

var on := false:
	set(value):
		on = value
		sprite.frame = int(on)
		toggled.emit(on)

@onready var sprite: Sprite2D = $Sprite


func _on_body_entered(_body: Node2D = null) -> void:
	if get_overlapping_bodies().size() == 1:
		on = true


func _on_body_exited(_body: Node2D = null) -> void:
	if get_overlapping_bodies().size() <= 0:
		on = false
