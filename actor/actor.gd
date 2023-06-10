class_name Actor
extends CharacterBody2D


@export var speed := 64
@export var max_hp := 100# scale of hp might need to be changed
@export var dex := 300

var hp := max_hp:
	set(value):
		hp = min(value, max_hp)
		_die()


func _die() -> void:
	queue_free()# Default behavior


func _on_hit_box_dmg_taken(amount: int) -> void:
	hp -= amount
