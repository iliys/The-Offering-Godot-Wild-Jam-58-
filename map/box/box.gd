class_name Box
extends RigidBody2D


@onready var anti_freeze_zone: Area2D = $AntiFreezeZone


func _on_anti_freeze_zone_body_entered(_body: Node2D) -> void:
	set_deferred("freeze", false)


func _on_anti_freeze_zone_body_exited(_body: Node2D) -> void:
	if anti_freeze_zone.get_overlapping_bodies().size() > 0:
		return
	set_deferred("freeze", true)
