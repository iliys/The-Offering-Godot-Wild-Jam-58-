class_name HealthPickup
extends Area2D


@export var strength := 2

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer


func _on_body_entered(body: Node2D) -> void:
	if body.hp >= body.max_hp:
		return
	body.hp += strength

	collision_shape.disabled = true
	sprite.visible = false
	audio_player.play()


func _on_audio_stream_player_finished() -> void:
	queue_free()
