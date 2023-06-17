extends Control


@onready var gwj_logo: TextureRect = $gwj_logo
@onready var gwj_theme: TextureRect = $gwj_theme
@onready var gwj_cards: TextureRect = $gwj_cards
@onready var background: TextureRect = $background
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var play_button: AudibleButton = $PlayButton


func _ready() -> void:
	animation_player.play("logo")


func _input(event: InputEvent) -> void:
	animation_player.animation_set_next("logo", "IDLE")


func _on_play_button_pressed() -> void:
	play_button.disabled = true
	animation_player.play("end")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "end":
		var level := preload("res://map/map2.tscn")
		var error := get_tree().change_scene_to_packed(level)
		if error != OK:
			OS.alert("Could not load game.")
