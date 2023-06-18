class_name SwordPickup
extends Area2D


const SWORD := preload("res://combat_boxes/hurt_box/sword.tscn")
const ICON := preload("res://ui/icons/sword.png")

@onready var sprite: Sprite2D = $Sprite
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var collision_shape: CollisionShape2D = $CollisionShape


func _on_body_entered(body: Node2D) -> void:
	body.set_tool("R", SWORD, ICON)
	collision_shape.set_deferred("disabled", true)
	sprite.hide()
	sound.play()


func _on_sound_finished() -> void:
	queue_free()
