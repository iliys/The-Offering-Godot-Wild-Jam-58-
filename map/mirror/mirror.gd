class_name Mirror
extends StaticBody2D


@onready var sprite: Sprite2D = $Sprite
@onready var light_beam: RayCast2D = $LightBeam


func rotate_mirror() -> void:
	light_beam.rotate(PI / 2)
	light_beam.rotation_degrees = int(light_beam.rotation_degrees) % 360
	if (is_equal_approx(light_beam.rotation_degrees, 0)
			or is_equal_approx(light_beam.rotation_degrees, 180)):
		sprite.frame = 3
	else:
		sprite.frame = 1


func _on_hit_box_dmg_taken(_amount: int, attacker: Actor) -> void:
	if attacker is Enemy:
		return
	rotate_mirror()
