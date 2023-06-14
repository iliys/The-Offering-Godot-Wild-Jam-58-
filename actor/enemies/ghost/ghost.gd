class_name Ghost
extends Enemy


const PETRIFIED_GHOST := preload("res://map/box/petrified_ghost.tscn")


func _go_to_location(location: Vector2, speed_mod := 1.0) -> void:
	velocity = global_position.direction_to(location) * speed * speed_mod


func petrify(location: Vector2) -> void:
	var petrified_ghost: PetrifiedGhost = PETRIFIED_GHOST.instantiate()
	# VERY BAD CODE!!! But the quicker, the better.
	var tile_map: TileMap = get_tree().current_scene.find_child("TileMap")
	petrified_ghost.tile_map = tile_map
	call_deferred("add_sibling", petrified_ghost)
	petrified_ghost.global_position = tile_map.map_to_local(tile_map.local_to_map(location))
	queue_free()
