class_name MirrorShieldPickup
extends Area2D


const MIRROR_SHIELD := preload("res://items/mirror_shield/mirror_shield.tscn")
const ICON := preload("res://ui/icons/shield.png")


func _on_body_entered(body: Node2D) -> void:
	body.set_tool("L", MIRROR_SHIELD, ICON)
	queue_free()
