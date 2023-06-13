class_name Reflective
extends Area2D


const LIGHT_BEAM := preload("res://map/mirror/light_beam/light_beam.tscn")

# Represented through bool because there are two angles
@export var angle := true
var light_sources: Dictionary = {}

@onready var light_beams: Node2D = $LightBeams


func rotate_mirror() -> void:
	angle = not angle
	for id in light_sources.keys():
		rotate_beam(id)


func rotate_beam(id: int) -> void:
	var light_beam: RayCast2D = light_beams.get_node(str(id))
	var light_source: Vector2 = light_sources[id]
	var deg_45 := (PI / 4)

	var normal := -light_source.rotated(deg_45 * Reflective.bool2weight(angle) * Reflective.bool2weight(light_source.y == 0.0))
	light_beam.rotation = light_source.bounce(normal).angle()


func add_beam(source: Vector2, id: int) -> void:
	if has_node(str(id)):
		return

	light_sources[id] = source
	var light_beam: LightBeam = LIGHT_BEAM.instantiate()
	light_beam.name = str(id)
	light_beams.add_child(light_beam, true)
	rotate_beam(id)


func remove_beam(id: int) -> void:
	var light_beam: RayCast2D = light_beams.get_node(str(id))
	if light_beam.reflector != null:
		light_beam.reflector = null
	light_beam.queue_free()
	light_sources.erase(id)


func clear_beams() -> void:
	for light_beam in light_beams.get_children():
		if light_beam.reflector != null:
			light_beam.reflector = null
		light_beam.queue_free()
	light_sources.clear()


static func bool2weight(value: bool) -> float:
	return float(value) * 2.0 - 1.0
