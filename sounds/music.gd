extends AudioStreamPlayer


func set_track(to: AudioStream) -> void:
	if stream == to:
		return

	if to != null:
		volume_db = 0
		stream = to
		play()
	else:
		create_tween().tween_property(self, "volume_db", -80, 1.0)


func _on_finished() -> void:
	play()
