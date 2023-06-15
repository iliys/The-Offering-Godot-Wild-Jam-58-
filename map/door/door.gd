class_name Door
extends StaticBody2D


@export var id := -1
@export var open_by_interact := true
@export var open := true

var close_anim_name := "closed"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var interation_zone: Area2D = $InteractionZone
@onready var non_close_zone: Area2D = $NonCloseZone


func _ready() -> void:
	if id >= 0:
		close_anim_name = "closed_locked"
	set_open(open)


func open_w_key(player: Player) -> void:
	if (not player.keys.has(id)) or player.keys[id] <= 0:
		return

	player.modify_key_count(id, -1)
	set_open(true)


@warning_ignore("shadowed_variable")
func set_open(open := true) -> void:
	if non_close_zone.get_overlapping_bodies().size() > 0:
		return
	self.open = open
	animated_sprite.play("open" if open else close_anim_name)
	collision_shape.set_deferred("disabled", open)


func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if open or not open_by_interact:
		return
	if id >= 0:
		open_w_key(body)
	else:
		set_open(true)
