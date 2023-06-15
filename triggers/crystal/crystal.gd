class_name Crystal
extends Area2D


signal activated

var on := false#:
#	set(value):
#		if on == value:
#			return
#		on = value
#		sprite.frame = int(on)
#		active_set.emit(on)

@onready var sprite: Sprite2D = $Sprite


func activate() -> void:
	if on:
		return
	on = true
	sprite.frame = 1
	activated.emit()
