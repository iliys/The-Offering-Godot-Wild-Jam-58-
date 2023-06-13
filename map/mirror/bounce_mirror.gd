class_name BounceMirror
extends StaticBody2D


const LIGHT_BEAM := preload("res://map/mirror/light_beam/light_beam.tscn")

@export var angle := true:
	set(value):
		angle = value
		if angle:
			sprite.frame = 2
		else:
			sprite.frame = 0
@onready var sprite: Sprite2D = $Sprite
@onready var reflective: Reflective = $Reflective


func _ready() -> void:
	reflective.angle = angle


func _on_hit_box_dmg_taken(_amount: int, attacker: Actor) -> void:
	if attacker is Enemy:
		return
	reflective.rotate_mirror()
	angle = reflective.angle


static func bool2weight(value: bool) -> float:
	return float(value) * 2.0 - 1.0
