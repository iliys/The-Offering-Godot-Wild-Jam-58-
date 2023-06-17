class_name GroundEnemy
extends Enemy


@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")


func _go_to_location(location: Vector2, speed_mod := 1.0) -> void:
	navigation_agent.target_position = location
	var next_path_pos := navigation_agent.get_next_path_position()
	if global_position.distance_to(next_path_pos) >= min_move_distance:
		var direction := global_position.direction_to(next_path_pos)
		velocity = direction * speed * speed_mod
	else:
		velocity = Vector2()

	animate()


func animate() -> void:
	animation_tree.set("parameters/Run/blend_position", velocity)
	animation_tree.set("parameters/Idle/blend_position", velocity)
	animation_tree.set("parameters/Attack/blend_position", velocity)
	if velocity.length() > 0:
		playback.travel("Run")
	else:
		playback.travel("Idle")


func _on_hurt_box_attacked() -> void:
	# Won't play.
	playback.travel("Attack")
