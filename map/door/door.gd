class_name Door
extends StaticBody2D


@export var id := -1
@export var open_by_interact := true
@export var open := false

var close_anim_name := "closed"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var interation_zone: Area2D = $InteractionZone


func _ready() -> void:
	if id >= 0:
		close_anim_name = "closed_locked"
	set_open(open)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interation_zone.get_overlapping_bodies().size() > 0:
		if id >= 0:
			open_w_key()
		elif open_by_interact:
			set_open(not open)


func open_w_key() -> void:
	var player: Player = interation_zone.get_overlapping_bodies()[0]
	if (not player.keys.has(id)) or player.keys[id] <= 0:
		return

	player.modify_key_count(id, -1)
	set_open(true)


@warning_ignore("shadowed_variable")
func set_open(open := true) -> void:
	self.open = open
	animated_sprite.play("open" if open else close_anim_name)
	collision_shape.set_deferred("disabled", open)
