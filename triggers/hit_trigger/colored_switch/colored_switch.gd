class_name ColoredSwitch
extends Node2D


@export var red_up := true
@export var red_img: Texture2D
@export var yellow_img: Texture2D

@onready var red: Node2D = $Red
@onready var yellow: Node2D = $Yellow


func _ready() -> void:
	set_gates(red, red_up)
	set_gates(yellow, not red_up)
	init_gates(red, red_img)
	init_gates(yellow, yellow_img)


func set_gates(gates: Node2D, up: bool) -> void:
	for gate in gates.get_children():
		gate.active = up


func init_gates(gates: Node2D, img: Texture2D) -> void:
	gates.modulate = Color.WHITE
	for gate in gates.get_children():
		gate.set_collision_layer_value(8, false)
		gate.set_collision_layer_value(10, true)
		gate.sprite.texture = img


func _on_hit_trigger_toggled(_on: bool) -> void:
	red_up = not red_up
	set_gates(red, red_up)
	set_gates(yellow, not red_up)
