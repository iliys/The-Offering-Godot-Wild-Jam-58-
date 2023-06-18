extends AudioStreamPlayer


func set_playing(to: bool) -> void:
	if to:
		volume_db = 0
		play()
	else:
		create_tween().tween_property(self, "volume_db", -80, 1.0)
