class_name Altar
extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	var scene := "res://ui/lose_screen/lose_screen.tscn"
	var error := get_tree().change_scene_to_file(scene)
	if error != OK:
		OS.alert("Could not load scene ", scene)
