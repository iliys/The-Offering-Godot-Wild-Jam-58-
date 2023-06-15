class_name SwordPickup
extends Area2D


const SWORD := preload("res://combat_boxes/hurt_box/sword.tscn")
const ICON := preload("res://ui/icons/sword.png")


func _on_body_entered(body: Node2D) -> void:
	body.set_tool("R", SWORD, ICON)
	queue_free()
