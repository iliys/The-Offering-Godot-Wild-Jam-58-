class_name MirrorShieldPickup
extends Area2D


const MIRROR_SHIELD := preload("res://items/mirror_shield/mirror_shield.tscn")
const ICON := preload("res://ui/icons/shield.png")

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var sound: AudioStreamPlayer2D = $Sound


func _on_body_entered(body: Node2D) -> void:
	body.set_tool("L", MIRROR_SHIELD, ICON)
	collision_shape.disabled = true
	sprite.hide()
	sound.play()


func _on_sound_finished() -> void:
	queue_free()
