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


# Called by light beam when just hit this.
func add_beam(source: Vector2, id: int) -> void:
	if has_node(str(id)):
		return

	light_sources[id] = source
	var light_beam: LightBeam = LIGHT_BEAM.instantiate()
	light_beam.modulate.b = instance_from_id(id).modulate.b / 1.5
	light_beam.name = str(id)
	light_beams.add_child(light_beam, true)
	rotate_beam(id)


# Called by light beam when exited this.
func remove_beam(id: int) -> void:
	var light_beam: RayCast2D = light_beams.get_node(str(id))
	# remove child beams
	if light_beam.reflector != null:# If it's not even hiting anything, then it doesn't have any child beams.
		var origin: Node2D = light_beam# Dont work: instance_from_id(id)
		print("origin: ", origin)
		origin.modulate = Color.RED
		var child_light: Node2D = find_child_light(origin, light_beam.reflector.light_beams.get_children())

		if child_light != null:
			light_beam.reflector.remove_beam(int(str(child_light.name)))
			print("removed nested beam.")

	# Remove this beam
	light_beam.queue_free()
	light_sources.erase(id)


func find_child_light(of: Node2D, from_list: Array[Node]) -> Node2D:
	for node in from_list:
		var node_origin: Node2D = instance_from_id(int(str(node.name)))
		node_origin.modulate = Color.BLUE
		#get_tree().paused = true
		print("Node origin: ", node_origin)
		if node_origin == of:
			print("success!")
			return node

	return null


#func clear_beams() -> void:
#	light_sources.clear()
#	for light_beam in light_beams.get_children():
#		if light_beam.reflector != null and light_beam.reflector.light_sources.keys().size() > 0:
#			light_beam.reflector.clear_beams()
#		light_beam.queue_free()


static func bool2weight(value: bool) -> float:
	return float(value) * 2.0 - 1.0
