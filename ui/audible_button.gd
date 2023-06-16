class_name AudibleButton
extends TextureButton


@onready var sound: AudioStreamPlayer = $Sound


func _on_pressed() -> void:
	sound.play()
