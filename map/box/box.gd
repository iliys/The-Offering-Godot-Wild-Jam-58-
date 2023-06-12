class_name Box
extends StaticBody2D


@export var slide_duration := 0.5

var tile_map: TileMap = null
var moving := false

@onready var grid_size := tile_map.tile_set.tile_size


func push(direction: Vector2) -> void:
	if moving:
		return
	var motion := direction * Vector2(grid_size)
	if test_move(transform.scaled_local(Vector2(0.9, 0.9)), motion, null, 0.0):
		return

	var final_pos := position + motion
	var tween := create_tween()
	tween.tween_property(self, "position", final_pos, slide_duration)
	moving = true
	tile_map.set_cell(1, tile_map.local_to_map(position), 1, Vector2i(1, 1))
	tile_map.erase_cell(1, tile_map.local_to_map(final_pos))
	await tween.finished
	moving = false
