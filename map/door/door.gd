class_name Door
extends StaticBody2D


@export var open_by_interact := true
@export var id := -1
@export var open_count := 1
@export var needed_to_trigger := 1
@export var lock_on_enter := false
@export var gem_door := false

var close_anim_name := "closed"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var interation_zone: Area2D = $InteractionZone
@onready var non_close_zone: Area2D = $NonCloseZone
@onready var one_way: Area2D = $OneWay
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if gem_door:
		close_anim_name = "closed_gem"
	elif id >= 0:
		close_anim_name = "closed_locked"
	test_open()


func open_w_key(player: Player) -> void:
	if (not player.keys.has(id)) or player.keys[id] <= 0:
		return

	player.modify_key_count(id, -1)
	set_open(true)


@warning_ignore("shadowed_variable")
func set_open(open := true) -> void:
	if non_close_zone.get_overlapping_bodies().size() > 0:
		return
	open_count += int(open) * 2 - 1
	test_open()


func test_open() -> void:
	if open_count >= needed_to_trigger:
		audio_player.play()
		animated_sprite.play("open_gem" if gem_door else "open")
		collision_shape.set_deferred("disabled", true)
	else:
		animated_sprite.play(close_anim_name)
		collision_shape.set_deferred("disabled", false)


func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if open_count >= needed_to_trigger or not open_by_interact:
		return
	if id >= 0:
		open_w_key(body)
	else:
		set_open(true)


func _on_lock_zone_body_exited(_body: Node2D) -> void:
	if one_way.get_overlapping_bodies().size() <= 0 or not lock_on_enter:
		return
	open_count = 0
	test_open()
