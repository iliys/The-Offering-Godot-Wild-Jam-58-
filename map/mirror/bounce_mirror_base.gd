class_name BounceMirror
extends HitBox


const LIGHT_BEAM := preload("res://map/mirror/light_beam/light_beam.tscn")

@export var angle := true:
	set(value):
		angle = value
		if not is_ready:
			await ready
		if angle:
			sprite.frame = 2
		else:
			sprite.frame = 0

var is_ready := false

@onready var sprite: Sprite2D = $Sprite
@onready var reflective: Reflective = $Reflective


func _ready() -> void:
	is_ready = true
	reflective.angle = angle


static func bool2weight(value: bool) -> float:
	return float(value) * 2.0 - 1.0


func _on_dmg_taken(_amount: int, attacker: Actor) -> void:
	if attacker is Enemy:
		return
	reflective.rotate_mirror()
	angle = reflective.angle
