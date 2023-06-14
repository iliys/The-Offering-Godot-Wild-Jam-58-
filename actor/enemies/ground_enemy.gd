class_name GroundEnemy
extends Enemy


@onready var navigation_agent: NavigationAgent2D = $NavigationAgent


func _go_to_location(location: Vector2, speed_mod := 1.0) -> void:
	navigation_agent.target_position = location
	var next_path_pos := navigation_agent.get_next_path_position()
	if global_position.distance_to(next_path_pos) >= min_move_distance:
		var direction := global_position.direction_to(next_path_pos)
		velocity = direction * speed * speed_mod
	else:
		velocity = Vector2()
