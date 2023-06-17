class_name EndScreen
extends Control


@onready var restart_button: AudibleButton = $RestartButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "restart":
		var level := preload("res://map/map2.tscn")
		var error := get_tree().change_scene_to_packed(level)
		if error != OK:
			OS.alert("Could not load game.")


func _on_restart_button_pressed() -> void:
	animation_player.play("restart")
	restart_button.disabled = true
