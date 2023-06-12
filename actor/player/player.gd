# Might be good to use a state machine.
class_name Player
extends Actor


signal max_hp_initialized(max_hp: int)
signal key_count_changed(count: int)

@export var attack_speed_factor := 0.0
@export var inertia := 128
#@export var swing_speed := 20

var attacking := false
var last_dir := Vector2.RIGHT
var keys := {}# {id: amount}

@onready var hand: Marker2D = $Hand
@onready var weapon: HurtBox = hand.get_node("Weapon")


func _ready() -> void:
	max_hp_initialized.emit(max_hp)
	hp_changed.emit(hp)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()


func _physics_process(delta: float) -> void:
	move(delta)
	if Input.is_action_pressed("interact"):
		shove_boxes(delta)


func _die() -> void:
	get_tree().reload_current_scene()


func move(delta: float) -> void:
	if not stunned:
		var direction := Input.get_vector("left", "right", "up", "down")
		if direction.length() > 0:
			last_dir = direction
		var speed_mod := attack_speed_factor if attacking else 1.0
		smooth_set_vel(direction * speed * speed_mod, delta)
	else:
		smooth_set_vel(Vector2(), delta)
	
	var prioritized_dir := last_dir
	prioritized_dir.x *= 1.5
	var target_rotation := snappedf(prioritized_dir.angle(), PI / 2)
	#hand.rotation = lerp_angle(hand.rotation, target_rotation, swing_speed * delta)
	hand.rotation = target_rotation

	move_and_slide()


func attack() -> void:
	weapon.attack()
	# Do some animation.


func shove_boxes(delta: float) -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider in get_tree().get_nodes_in_group("boxes"):
			(collider as RigidBody2D).apply_impulse(-collision.get_normal() * inertia)# * delta)


func modify_key_count(id: int, modifer: int) -> void:
	if keys.has(id):
		keys[id] += modifer
		keys[id] = max(0, keys[id])
	elif modifer > 0:
		keys[id] = modifer

	if id == 0:
		key_count_changed.emit(keys[id])


func _on_weapon_attack_finished() -> void:
	stunned = false


func _on_weapon_attacked() -> void:
	stunned = true
