class_name HealthPickup
extends Area2D


@export var strength := 2

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_body_entered(body: Node2D) -> void:
	if body.hp >= body.max_hp:
		return
	body.hp += strength
	queue_free()
