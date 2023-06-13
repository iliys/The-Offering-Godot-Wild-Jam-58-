class_name Door
extends StaticBody2D


@export var id := -1

var close_anim_name := "closed"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var interation_zone: Area2D = $InteractionZone


func _ready() -> void:
	if id < 0:
		interation_zone.queue_free()
	else:
		close_anim_name = "closed_locked"
	animated_sprite.play(close_anim_name)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and id >= 0:
		open_w_key()


func open_w_key() -> void:
	if interation_zone.get_overlapping_bodies().size() <= 0:
		return
	var player: Player = interation_zone.get_overlapping_bodies()[0]
	if (not player.keys.has(id)) or player.keys[id] <= 0:
		return

	player.modify_key_count(id, -1)
	set_open(true)


func set_open(open := true) -> void:
	animated_sprite.play("open" if open else close_anim_name)
	collision_shape.set_deferred("disabled", open)
