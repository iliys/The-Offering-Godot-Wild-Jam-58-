class_name Ghost
extends Enemy


const PETRIFIED_GHOST := preload("res://map/box/petrified_ghost.tscn")


func _go_to_location(location: Vector2, speed_mod := 1.0) -> void:
	velocity = global_position.direction_to(location) * speed * speed_mod


func petrify() -> void:
	var petrified_ghost: StaticBody2D = PETRIFIED_GHOST.instantiate()
	call_deferred("add_sibling", petrified_ghost)
	petrified_ghost.global_position = global_position.snapped((Vector2.ONE * 16.0)) + (Vector2.ONE * 8.0)
	queue_free()
