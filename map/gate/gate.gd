class_name Gate
extends StaticBody2D


@export var active := true:
	set(value):
		if (not active) and value and (detector.get_overlapping_areas().size() > 0
				or detector.get_overlapping_bodies().size() > 0):
			return
		active = value
		collision_shape.set_deferred("disabled", not active)
		sprite.frame = int(active)

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var detector: Area2D = $detector


# Signal should be connected to this method.
func set_active(value: int) -> void:
	active = value


func _on_standing_trigger_toggled(on):
	set_active(0)


func _on_standing_trigger_body_exited(body):
	set_active(1)

