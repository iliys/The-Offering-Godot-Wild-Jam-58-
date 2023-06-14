class_name Crystal
extends Area2D


signal active_set(on: bool)

var on := false:
	set(value):
		print("set")
		if on == value:
			return
		on = value
		sprite.frame = int(on)
		active_set.emit(on)

@onready var sprite: Sprite2D = $Sprite
