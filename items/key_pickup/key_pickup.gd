class_name KeyPickup
extends Area2D


@export var id := 0


func _on_body_entered(body: Node2D) -> void:
	body.modify_key_count(id, 1)
	queue_free()
