class_name UI
extends CanvasLayer


@onready var hp_bar: Control = $HPBar
@onready var bg: TextureRect = hp_bar.get_node("BG")
@onready var fill: TextureRect = hp_bar.get_node("Fill")
@onready var items: VBoxContainer = $Items


func init_max_hp(max_hp: int) -> void:
	@warning_ignore("integer_division")
	bg.size.x = bg.texture.get_width() * max_hp / 2
	display_hp(max_hp)


func display_hp(hp: int) -> void:
	@warning_ignore("integer_division")
	fill.size.x = fill.texture.get_width() * hp / 2


func set_key_count(id: int, count: int) -> void:
	var counter: TextureRect = items.get_node("Key" + str(id))
	counter.custom_minimum_size = Vector2(counter.texture.get_width() * count,
			counter.texture.get_height() if count > 0 else 0)
