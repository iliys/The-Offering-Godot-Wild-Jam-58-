class_name HitTrigger
extends HitBox


signal toggled(on: bool)

var on := false

@onready var sprite: Sprite2D = $Sprite


func take_dmg(_dmg: int, attacker: Actor) -> void:
	if attacker is Enemy:
		return
	
	on = not on
	sprite.frame = int(on)
	toggled.emit(on)
