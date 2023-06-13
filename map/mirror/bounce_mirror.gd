class_name BounceMirror
extends StaticBody2D


const LIGHT_BEAM := preload("res://map/mirror/light_beam/light_beam.tscn")

# Represented through bool because there are two angles
@export var angle := true:
	set(value):
		angle = value
		if angle:
			sprite.frame = 2
		else:
			sprite.frame = 0
var light_sources: Dictionary = {}# {id: source}#:
#	set(value):
#		light_sources = value
#		if light_source != Vector2():
#			if not has_node("LightBeam"):
#				var light_beam: RayCast2D = LIGHT_BEAM.instantiate()
#				add_child(light_beam, true)
#				light_beam.position.y -= 4
#				rotate_beam()
#		elif has_node("LightBeam"):
#			var light_beam: LightBeam = get_node("LightBeam")
#			if light_beam.bounce_mirror != null:
#				light_beam.bounce_mirror.light_source = Vector2()
#			get_node("LightBeam").queue_free()

@onready var sprite: Sprite2D = $Sprite
@onready var light_beams: Node2D = $LightBeams


func rotate_mirror() -> void:
	angle = not angle
	for id in light_sources.keys():
		rotate_beam(id)
	#if light_source != Vector2():
	#	rotate_beam()


func rotate_beam(id: int) -> void:
	var light_beam: RayCast2D = light_beams.get_node(str(id))
	var light_source: Vector2 = light_sources[id]
	light_beam.rotation = light_source.bounce(-light_source.rotated(
			((PI / 4) * BounceMirror.bool2weight(angle)
			* BounceMirror.bool2weight(light_source.y == 0.0))
			)).angle()


#func rotate_beam() -> void:
#	var light_beam: LightBeam = $LightBeam
#	light_beam.rotation = light_source.bounce(-light_source.rotated(
#			((PI / 4) * BounceMirror.bool2weight(angle)
#			* BounceMirror.bool2weight(light_source.y == 0.0))
#			)).angle()
	#light_beam.rotation = light_source.rotated((PI / 2) * (float(angle) * 2.0 - 1.0)).angle()


func add_beam(source: Vector2, id: int) -> void:
	if has_node(str(id)):
		return

	light_sources[id] = source
	var light_beam: RayCast2D = LIGHT_BEAM.instantiate()
	light_beam.name = str(id)
	light_beams.add_child(light_beam, true)
	rotate_beam(id)


func remove_beam(id: int) -> void:
	light_beams.get_node(str(id)).queue_free()
	light_sources.erase(id)


func _on_hit_box_dmg_taken(_amount: int, attacker: Actor) -> void:
	if attacker is Enemy:
		return
	rotate_mirror()


static func bool2weight(value: bool) -> float:
	return float(value) * 2.0 - 1.0
