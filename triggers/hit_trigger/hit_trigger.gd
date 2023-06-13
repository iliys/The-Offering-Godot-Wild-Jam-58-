class_name HitTrigger
extends HitBox


signal toggled(on: bool)

@export var on := false

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	sprite.frame = int(on)


func take_dmg(_dmg := 0, attacker: Actor = null) -> void:
	if attacker is Enemy:
		return

	on = not on
	sprite.frame = int(on)
	toggled.emit(on)
