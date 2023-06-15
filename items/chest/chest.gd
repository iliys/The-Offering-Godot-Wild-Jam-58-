class_name Chest
extends StaticBody2D


@export var id := -1
@export var drops: Array[PackedScene] = []
@export var drop_distance := 16

var is_open := false


func open() -> void:
	if is_open:
		return

	var interact_zone: Area2D = $InteractZone
	interact_zone.queue_free()
	var animated_sprite: AnimatedSprite2D = $AnimatedSprite
	animated_sprite.play("open")

	var start_rot := randf_range(-PI, PI)
	for i in drops.size():
		var drop: Node2D = drops[i].instantiate()
		call_deferred("add_sibling", drop)
		drop.global_position = global_position + (Vector2(drop_distance, 0.0).rotated(
				start_rot + TAU / drops.size() * i))

	is_open = true


func _on_interact_zone_body_entered(body: Node2D) -> void:
	if is_open:
		return
	var player: Player = body
	if id >= 0:
		if (not player.keys.has(id)) or player.keys[id] <= 0:
			return
		player.modify_key_count(id, -1)

	open()
