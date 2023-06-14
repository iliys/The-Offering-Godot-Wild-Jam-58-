class_name ColoredSwitch
extends Node2D


@export var red_up := true

@onready var red: Node2D = $Red
@onready var blue: Node2D = $Blue


func _ready() -> void:
	set_gates(red, red_up)
	set_gates(blue, not red_up)


func set_gates(gates: Node2D, up: bool) -> void:
	for gate in gates.get_children():
		gate.active = up


func _on_hit_trigger_toggled(_on: bool) -> void:
	red_up = not red_up
	set_gates(red, red_up)
	set_gates(blue, not red_up)
