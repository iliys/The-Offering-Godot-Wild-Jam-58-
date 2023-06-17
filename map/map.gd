class_name Map
extends Node2D


# Using enum because I don't know how to get layers by name directly from TileMap.
enum LAYERS {
	MAIN,
	NAVIGATION,
	BOX_SLOTS,
	BOXES,
}

# Calling it BOX rather than Box, because of potential conflicts with class names.
const BOX := preload("res://map/box/box.tscn")

@onready var tile_map: TileMap = $TileMap
@onready var boxes: Node2D = $Boxes


func _ready() -> void:
	randomize()
	tile_map.set_layer_modulate(LAYERS.NAVIGATION, Color.TRANSPARENT)
	load_boxes()


func load_boxes() -> void:
	# TileSetScenesCollectionSource might be able to do the instantiation.
	for tile in tile_map.get_used_cells(LAYERS.BOXES):
		var box: Box = BOX.instantiate()
		#box.tile_map = tile_map
		box.position = tile_map.map_to_local(tile)
		boxes.add_child(box)
		tile_map.erase_cell(LAYERS.NAVIGATION, tile)

	tile_map.set_layer_enabled(LAYERS.BOXES, false)
