class_name HitTrigger
extends HitBox


signal toggled(on: bool)

@export var on := false

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	sprite.frame = int(on)


func _on_dmg_taken(_amount: int, _attacker: Actor) -> void:
	on = not on
	sprite.frame = int(on)
	toggled.emit(on)
