class_name MirrorShield
extends Node2D


signal activated
signal finished

const LIGHT_BEAM := preload("res://map/mirror/light_beam/light_beam.tscn")

var in_light := false:
	set(value):
		if value and not in_light:
			light_beam = LIGHT_BEAM.instantiate()
			call_deferred("add_child", light_beam)
			light_beam.position.x += 4
		in_light = value
var cooling := false
var blocking := false
var got_hit := false
var light_beam: RayCast2D = null

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var draw_time: Timer = $DrawTime
@onready var block_duration: Timer = $BlockDuration
@onready var cool_down: Timer = $Cooldown
@onready var hit_box_shape: CollisionShape2D = $HitBox/CollisionShape


func block() -> void:
	if cooling:
		return

	cooling = true
	blocking = true
	draw_time.start()
	activated.emit()


func _on_cooldown_timeout() -> void:
	cooling = false


func _on_draw_time_timeout() -> void:
	sprite.show()
	sprite.global_rotation = 0.0
	hit_box_shape.set_deferred("disabled", false)
	collision_shape.set_deferred("disabled", false)
	block_duration.start()


func _on_block_duration_timeout() -> void:
	blocking = false
	sprite.hide()
	hit_box_shape.set_deferred("disabled", true)
	collision_shape.set_deferred("disabled", true)
	if light_beam != null:
		light_beam.queue_free()
	if got_hit:
		cool_down.start()
		got_hit = false
	else:
		await RenderingServer.frame_pre_draw
		cooling = false

	finished.emit()


func _on_hit_box_dmg_taken(_amount: int, _attacker: Actor) -> void:
	got_hit = true
