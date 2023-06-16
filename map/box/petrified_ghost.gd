class_name PetrifiedGhost
extends Box


func _ready() -> void:
	$Label.text = str(global_position)
	pass # Wil have to do somthing to make the ghost point in the last direction it was facing.
