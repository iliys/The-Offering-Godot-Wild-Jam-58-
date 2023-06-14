# Adds beam to reflector when just hit
# Removes beam from reflector when just exited
# Simple!
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
	collision_shape.shape = collision_shape.shape.duplicate()


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
	if get_collider().light_sources.keys().size() > 2:# If the reflector has more than two light sources
		return

	reflector = get_collider()
	var light_source := global_position.direction_to(reflector.global_position
			).snapped(Vector2.ONE)
	reflector.add_beam(light_source, get_instance_id())


func adjust_length(collision_point: Vector2) -> void:
	collision_shape.shape.b.x = collision_point.length() + 2
	end.position = collision_point
	sprite.scale.x = collision_point.length()


func _on_hit_zone_body_entered(body: Node2D) -> void:
	if body is Crystal:
		body.on = true


func _on_hit_zone_body_exited(body: Node2D) -> void:
	if body is Crystal:
		body.on = false
