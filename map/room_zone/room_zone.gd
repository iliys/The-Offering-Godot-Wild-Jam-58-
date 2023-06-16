class_name RoomZone
extends Area2D


@export_node_path var enemies

@onready var start_enemies: Array[Node] = []
@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape


func _ready() -> void:
	enemies = get_node(enemies)
	
	enemies.process_mode = Node.PROCESS_MODE_DISABLED

	for e in enemies.get_children():
		var enemy := dupllicate_node(e)
		start_enemies.append(enemy)

	sprite.position = collision_shape.position
	sprite.scale = (collision_shape.shape as RectangleShape2D).size


func reset() -> void:
	for enemy in enemies.get_children():
		enemy.queue_free()

	for e in start_enemies:
		var enemy := dupllicate_node(e)
		#enemy.reparent(enemies)
		enemies.add_child(enemy)


func dupllicate_node(node: Node) -> Node:
	var new_node := node.duplicate()
	new_node.owner = null

	return new_node


#func set_enabled(enabled: bool) -> void:
#	for body in get_overlapping_bodies():
#		if body is Enemy:
#			body.set_physics_process(enabled)


#func is_player_in_room() -> bool:
#	for body in get_overlapping_bodies():
#		if body is Player:
#			return true
#	return false


func _on_body_entered(_body: Node2D) -> void:
	sprite.hide()
	enemies.process_mode = Node.PROCESS_MODE_INHERIT
#	for enemy in enemies.get_children():
#		enemy.set_physics_process(true)
#	if body is Player:
#		sprite.hide()
#		set_enabled(true)
#	elif body is Enemy:
#		if is_player_in_room():
#			body.set_physics_process(true)
#		else:
#			body.set_physics_process(false)


func _on_body_exited(_body: Node2D) -> void:
	sprite.show()
	reset()
#	if body is Player:
#		sprite.show()
#		set_enabled(false)
