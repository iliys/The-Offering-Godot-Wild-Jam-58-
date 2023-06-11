class_name HitBox
extends Area2D


signal dmg_taken(amount: int, attacker: Actor)

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var immunity_time: Timer = $ImmunityTime


func take_dmg(dmg: int, attacker: Actor) -> void:
	dmg_taken.emit(dmg, attacker)
	hurt_sound.play()
	start_immunity()


func start_immunity() -> void:
	collision_shape.set_deferred("disabled", true)
	immunity_time.start()


func _on_immunity_time_timeout() -> void:
	collision_shape.set_deferred("disabled", false)
