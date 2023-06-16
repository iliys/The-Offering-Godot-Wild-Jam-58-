class_name HurtBox
extends Area2D


signal cool_down_finished
signal finished
signal activated

@export var dmg := 1

var cooling := false
var actor: Actor = null

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var attack_sound: AudioStreamPlayer2D = $AttackSound
@onready var cool_down: Timer = $CoolDown
@onready var attack_duration: Timer = $AttackDuration


func attack() -> void:
	if cooling:
		return
	collision_shape.set_deferred("disabled", false)
	attack_duration.start()
	cooling = true
	cool_down.start()
	activated.emit()


func _on_area_entered(area: Area2D) -> void:
	@warning_ignore("shadowed_variable")
	var actor: Actor = self.actor if self.actor != null else owner
	if area.owner == actor:# Prevents the user from hitting itself.
		return

	area.take_dmg(dmg, actor)
	attack_sound.play()


func _on_cool_down_timeout() -> void:
	cooling = false
	cool_down_finished.emit()


func _on_attack_duration_timeout() -> void:
	collision_shape.set_deferred("disabled", true)
	finished.emit()
