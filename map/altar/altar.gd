class_name Altar
extends Area2D


@onready var darkener: CanvasModulate = $Darkener


func _on_body_entered(body: Node2D) -> void:
	get_tree().paused = true
	Music.set_track(null)
	var tween := create_tween()
	tween.tween_property(darkener, "color", Color.BLACK, 1.0)
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false

	var scene := "res://ui/end_screen/end_screen.tscn"
	var error := get_tree().change_scene_to_file(scene)
	if error != OK:
		OS.alert("Could not load scene ", scene)
