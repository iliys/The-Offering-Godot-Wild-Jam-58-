class_name KeyPickup
extends Area2D


@export var id := 0
@export var active := true:
	set(value):
		active = value
		if not is_ready:
			await ready

		sprite.visible = active
		collision_shape.set_deferred("disabled", not active)

var is_ready := false

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var sound: AudioStreamPlayer2D = $Sound


func _ready() -> void:
	is_ready = true


func set_active(to := true) -> void:
	active = to


func _on_body_entered(body: Node2D) -> void:
	body.modify_key_count(id, 1)
	collision_shape.set_deferred("disabled", true)
	sound.play()


func _on_sound_finished() -> void:
	queue_free()
