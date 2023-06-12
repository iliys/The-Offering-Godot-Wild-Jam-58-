class_name Chest
extends StaticBody2D


@export var id := -1
@export var drops: Array[PackedScene] = []
@export var drop_distance := 16

var open := false


# Might should be on player.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if open:
			return
		var interact_zone: Area2D = $InteractZone
		if interact_zone.get_overlapping_bodies().size() <= 0:
			return
		var player: Player = interact_zone.get_overlapping_bodies()[0]
		if id >= 0:
			if (not player.keys.has(id)) or player.keys[id] <= 0:
				return
			player.modify_key_count(id, -1)

		interact_zone.queue_free()
		var animated_sprite: AnimatedSprite2D = $AnimatedSprite
		animated_sprite.play("open")
		var start_rot := randf_range(-PI, PI)
		for i in drops.size():
			var drop: Node2D = drops[i].instantiate()
			add_sibling(drop)
			drop.global_position = global_position + (Vector2(drop_distance, 0.0).rotated(
					start_rot + TAU / drops.size() * i))

		open = true
