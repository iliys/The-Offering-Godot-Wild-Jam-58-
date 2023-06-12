class_name Crystal
extends StaticBody2D


signal active_set(on: bool)

var on := false:
	set(value):
		if on == value:
			return
		on = value
		sprite.frame = int(on)
		active_set.emit(on)

@onready var sprite: Sprite2D = $Sprite
