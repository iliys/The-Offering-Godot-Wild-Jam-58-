class_name Box
extends StaticBody2D


@export var slide_duration := 0.5

var tile_map: TileMap = null

@onready var location := global_position
@onready var anti_freeze_zone: Area2D = $AntiFreezeZone
@onready var grid_size := tile_map.tile_set.tile_size


func push(direction: Vector2) -> void:
	var new_location := global_position + direction * Vector2(grid_size)
	for box in get_tree().get_nodes_in_group("boxes"):
		if box.location == new_location:
			return
	location = new_location
	create_tween().tween_property(self, "position", location, slide_duration)
