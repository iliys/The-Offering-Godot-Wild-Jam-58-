class_name UI
extends CanvasLayer


@onready var hp_bar: Control = $HPBar
@onready var bg: TextureRect = hp_bar.get_node("BG")
@onready var fill: TextureRect = hp_bar.get_node("Fill")
@onready var key_hud: HBoxContainer = $KeyHUD
@onready var counter: Label = key_hud.get_node("Counter")


func init_max_hp(max_hp: int) -> void:
	bg.size.x = bg.texture.get_width() * max_hp
	display_hp(max_hp)


func display_hp(hp: int) -> void:
	fill.size.x = fill.texture.get_width() * hp


func set_key_count(count: int) -> void:
	counter.text = str(count)
