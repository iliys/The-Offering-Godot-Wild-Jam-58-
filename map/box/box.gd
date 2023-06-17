class_name Box
extends StaticBody2D


@export var slide_duration := 0.5
@export var active := true:
	set(value):
		active = value
		if not is_ready:
			await ready
		sprite.visible = active
		collision_shape.set_deferred("disabled", not active)

var is_ready := false
var moving := false

@onready var tile_map: TileMap = get_tree().get_first_node_in_group("tile_maps")
@onready var grid_size := tile_map.tile_set.tile_size
@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape


func _ready() -> void:
	is_ready = true


@warning_ignore("shadowed_variable")
func set_active(active := false) -> void:
	self.active = active


func push(direction: Vector2) -> bool:
	if moving:
		return false
	var motion := direction * Vector2(grid_size)
	var final_pos := (position + motion).snapped(Vector2.ONE * Vector2(grid_size) / 2.0)
	var grooves := tile_map.get_used_cells(2)
	var in_grooves := tile_map.local_to_map(position) in grooves
	var is_final_pos_in_grooves := tile_map.local_to_map(final_pos) in grooves
	var has_move_space := test_move(transform.scaled_local(Vector2(0.9, 0.9)), motion, null, 0.0)
	if has_move_space or (in_grooves and not is_final_pos_in_grooves):
		return false

	var tween := create_tween()
	tween.tween_property(self, "position", final_pos, slide_duration)
	tween.finished.connect(func(): moving = false, CONNECT_ONE_SHOT)
	moving = true
	tile_map.set_cell(1, tile_map.local_to_map(position), 1, Vector2i(1, 1))
	tile_map.erase_cell(1, tile_map.local_to_map(final_pos))
	return true
