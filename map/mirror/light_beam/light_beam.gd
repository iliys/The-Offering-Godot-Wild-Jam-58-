class_name LightBeam
extends RayCast2D


var bounce_mirror: BounceMirror = null:
	set(value):
		if bounce_mirror == null:
			bounce_mirror = value
			return
		if value == null or bounce_mirror != value:
			bounce_mirror.remove_beam(get_instance_id())
			bounce_mirror = value

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $HitZone/CollisionShape
@onready var end: Sprite2D = $EndPoints/End


func _ready() -> void:
	collision_shape.shape = collision_shape.shape.duplicate()


func _physics_process(_delta: float) -> void:
	var collision_point := target_position
	if is_colliding():
		collision_point = to_local(get_collision_point())
		if get_collider() is BounceMirror:
			if get_collider() != bounce_mirror:
				bounce_mirror = get_collider()
				var light_source := global_position.direction_to( bounce_mirror.global_position
						).snapped(Vector2.ONE)
				bounce_mirror.add_beam(light_source, get_instance_id())
		elif bounce_mirror != null:
			bounce_mirror = null

	collision_shape.shape.b.x = collision_point.length() + 2
	end.position = collision_point
	sprite.scale.x = collision_point.length()


func _on_hit_zone_body_entered(body: Node2D) -> void:
	if body is Crystal:
		body.on = true


func _on_hit_zone_body_exited(body: Node2D) -> void:
	if body is Crystal:
		body.on = false
