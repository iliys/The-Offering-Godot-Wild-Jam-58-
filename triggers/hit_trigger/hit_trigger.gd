class_name HitTrigger
extends HitBox


signal toggled(on: bool)

var on := false

@onready var sprite: Sprite2D = $Sprite


# Note: will be triggered by an enemy attack as well.
func take_dmg(_dmg: int) -> void:
	on = not on
	sprite.frame = int(on)
	toggled.emit(on)
