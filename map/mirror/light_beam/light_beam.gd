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


#static func min_length(of: Vector2, min: float) -> Vector2:
#	return of if of.length() >= min else of.normalized() * min


func snap_to_tile(location: Vector2) -> Vector2:
	return (location + Vector2.ONE * 8.0).snapped(Vector2.ONE * 16.0) - Vector2.ONE * 8.0


func _on_hit_zone_body_entered(body: Node2D) -> void:
	if is_mirror_shield(body):
		body.in_light = true
	elif body is Ghost:
		var distance := global_position.distance_to(body.global_position)
		var ray_distance := to_local(get_collision_point()).x - 8.0
		distance = snappedf(clampf(distance, 16.0, ray_distance), 16.0)
		var local_location := Vector2.RIGHT.rotated(global_rotation) * distance
		var location := global_position + local_location
		location = snap_to_tile(location)
		
		var obstacles := []
		var hit_obstacle := false
		for obstacle in get_tree().get_nodes_in_group("obstacles"):
			if obstacle.get_node("CollisionShape").disabled == true:
				continue
			obstacles.append(obstacle)
			if (obstacle.global_position as Vector2).is_equal_approx(location):
				hit_obstacle = true
				print(hit_obstacle)
		if hit_obstacle:
			var obstacles_in_line: PackedVector2Array = []
			for obstacle in obstacles:
				var is_pointing_at_obstacle := is_equal_approx(
						global_position.angle_to_point(obstacle.global_position), global_rotation)
				var within_ray_distance := global_position.distance_to(obstacle.global_position) <= ray_distance
				if (is_pointing_at_obstacle and within_ray_distance):
					obstacles_in_line.append(obstacle.global_position)
					obstacle.modulate.b /= 1.5
					print(obstacle)
			for dist in range(distance, 16, int(ray_distance)):
				if global_position + (Vector2.RIGHT * dist).rotated(global_rotation) in obstacles_in_line:
			for dist in range(distance, -16, 0):
				pass

		body.petrify(location)


func _on_hit_zone_body_exited(body: Node2D) -> void:
	if is_mirror_shield(body):
		body.in_light = false


func _on_hit_zone_area_entered(area: Area2D) -> void:
	if area is Crystal:
		area.activate()


func _on_hit_zone_area_exited(area: Area2D) -> void:
	if area is Crystal:
		pass#area.on = false


func _on_tree_exiting() -> void:
	if reflector != null:
		var child_light: Node2D = find_child_light(reflector.light_beams.get_children())

		if child_light != null:
			reflector.remove_beam(int(str(child_light.name)))
