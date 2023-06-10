extends Node2D


@onready var tile_map: TileMap = $TileMap


func _ready() -> void:
	tile_map.set_layer_modulate(1, Color.TRANSPARENT)
