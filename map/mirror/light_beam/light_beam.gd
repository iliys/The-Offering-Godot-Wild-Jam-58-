class_name LightBeam
extends RayCast2D


var reflector: Area2D = null:
	set(value):
		if reflector == null:
			reflector = value
			return
		if value == null or reflector != value:
			reflector.remove_beam(get_instance_id())
			reflector = value

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $HitZone/CollisionShape
@onready var end: Sprite2D = $EndPoints/End


func _ready() -> void:
	collision_shape.set_deferred("shape", collision_shape.shape.duplicate())


func _physics_process(_delta: float) -> void:
	var collision_point := target_position
	if is_colliding():
		collision_point = to_local(get_collision_point())
		if get_collider() is Area2D and get_collider().get_collision_layer_value(7):
			if get_collider() != reflector:
				set_reflector()
		elif reflector != null:
			reflector = null

	adjust_length(collision_point)


func set_reflector() -> void:
	if get_collider().light_sources.keys().size() > 2:
		return

	reflector = get_collider()
	var light_source := global_position.direction_to(reflector.global_position
			).snapped(Vector2.ONE)
	reflector.add_beam(light_source, get_instance_id())


func adjust_length(collision_point: Vector2) -> void:
	collision_shape.shape.b.x = collision_point.length() + 2
	end.position = collision_point
	sprite.scale.x = collision_point.length()


func is_mirror_shield(what: Node2D) -> bool:
	return what is StaticBody2D and what.get_collision_layer_value(9) and what != owner


func find_child_light(from_list: Array[Node]) -> Node2D:
	for node in from_list:
		var node_origin: Node2D = instance_from_id(int(str(node.name)))
		if node_origin == self:
			return node

	return null


func _on_hit_zone_body_entered(body: Node2D) -> void:
	if is_mirror_shield(body):
		body.in_light = true


func _on_hit_zone_body_exited(body: Node2D) -> void:
	if is_mirror_shield(body):
		body.in_light = false


func _on_hit_zone_area_entered(area: Area2D) -> void:
	if area is Crystal:
		area.on = true


func _on_hit_zone_area_exited(area: Area2D) -> void:
	if area is Crystal:
		area.on = false


func _on_tree_exiting() -> void:
	if reflector != null:
		var child_light: Node2D = find_child_light(reflector.light_beams.get_children())

		if child_light != null:
			reflector.remove_beam(int(str(child_light.name)))
