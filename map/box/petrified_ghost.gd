class_name PetrifiedGhost
extends Box


var vel := Vector2():
	set(value):
		vel = value
		await ready
		animation_tree.set("parameters/blend_position", vel)

@onready var animation_tree: AnimationTree = $AnimationTree
