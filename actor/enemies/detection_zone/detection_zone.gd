class_name DetectionZone
extends Area2D


# TODO: Make system not only be able to see player but other stuff to (i.e. make more flexible).
var player: Player = null

@onready var ray_cast: RayCast2D = $RayCast


func _physics_process(_delta: float) -> void:
	if not ray_cast.enabled:
		return

	var target_player: Player = get_overlapping_bodies()[0]
	ray_cast.target_position = to_local(target_player.global_position)
	if ray_cast.is_colliding() and ray_cast.get_collider() is Player:
		player = target_player
	else:
		player = null


func _on_body_entered(_body: Node2D) -> void:
	ray_cast.enabled = true


func _on_body_exited(_body: Node2D) -> void:
	if get_overlapping_bodies().size() > 0:
		return
	ray_cast.enabled = false
	player = null
