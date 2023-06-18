class_name Totem
extends StaticBody2D


signal activated

@export var id := 3

@onready var sprite: Sprite2D = $Sprite
@onready var activate_sound: AudioStreamPlayer2D = $ActivateSound


func _ready() -> void:
	sprite.frame = id - 3


func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if (not body.keys.has(id)) or body.keys[id] <= 0:
		return

	body.modify_key_count(id, -1)
	var interaction_zone: Area2D = $InteractionZone
	interaction_zone.queue_free()
	sprite.texture = preload("res://New sprites/GuardStatuesFilled.png")
	activate_sound.play()
	activated.emit()
