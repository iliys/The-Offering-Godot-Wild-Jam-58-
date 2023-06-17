class_name Ghost
extends Enemy


const PETRIFIED_GHOST := preload("res://map/box/petrified_ghost.tscn")

@onready var animation_tree: AnimationTree = $AnimationTree


func _go_to_location(location: Vector2, speed_mod := 1.0) -> void:
	velocity = global_position.direction_to(location) * speed * speed_mod
	animation_tree.set("parameters/Move/blend_position", velocity)


func petrify(location: Vector2) -> void:
	var petrified_ghost: PetrifiedGhost = PETRIFIED_GHOST.instantiate()
	petrified_ghost.global_position = location
	petrified_ghost.vel = velocity
	call_deferred("add_sibling", petrified_ghost)
	queue_free()


#static func flr(value: float, step: float) -> float:
#	@warning_ignore("integer_division")
#	return float(int(value) / int(step)) * step
