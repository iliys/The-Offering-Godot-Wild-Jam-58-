class_name Ghost
extends Enemy


func _go_to_location(location: Vector2, speed_mod := 1.0) -> void:
	velocity = global_position.direction_to(location) * speed * speed_mod
