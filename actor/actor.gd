class_name Actor
extends CharacterBody2D


@export var speed := 64
@export var max_hp := 100# scale of hp might need to be changed
@export var dex := 300
@export var knock_back_factor := 2.0

var stunned := false
var hp := max_hp:
	set(value):
		hp = min(value, max_hp)
		if hp <= 0:
			_die()

@onready var knock_back_duration: Timer = $KnockBackDuration


func _die() -> void:
	queue_free()# Default behavior; overide with death anim.


func smooth_set_vel(to: Vector2, delta: float) -> void:
	velocity = velocity.move_toward(to, dex * delta)


func _on_hit_box_dmg_taken(amount: int, attacker: Actor) -> void:
	hp -= amount
	var knock_back_dir := attacker.global_position.direction_to(global_position)
	velocity = knock_back_dir * amount * knock_back_factor
	stunned = true
	knock_back_duration.start()


func _on_knock_back_duration_timeout() -> void:
	stunned = false
