# Might be good to use a state machine.
class_name Player
extends Actor


signal max_hp_initialized(max_hp: int)
signal key_count_changed(id: int, count: int)

@export var attack_speed_factor := 0.0
@export var inertia := 128
#@export var swing_speed := 20

var attacking := false
var sword_dir := Vector2.RIGHT
var keys := {}# {id: amount}

@onready var hand: Marker2D = $Hand
@onready var weapon: HurtBox = hand.get_node("Weapon")
@onready var shove_zone: Area2D = hand.get_node("ShoveZone")


func _ready() -> void:
	max_hp_initialized.emit(max_hp)
	hp_changed.emit(hp)


func _unhandled_input(event: InputEvent) -> void:
	if stunned:
		return
	if event.is_action_pressed("attack"):
		attack()
	elif event.is_action_pressed("interact"):
		shove_boxes()


func _physics_process(_delta: float) -> void:
	move()


func _die() -> void:
	get_tree().reload_current_scene()


func move() -> void:
	if not stunned:
		var direction := Input.get_vector("left", "right", "up", "down")
		if direction.length() > 0:
			sword_dir = direction
			sword_dir.x *= 2
			sword_dir = sword_dir.normalized().snapped(Vector2(1, 1))
		var speed_mod := attack_speed_factor if attacking else 1.0
		#smooth_set_vel(direction * speed * speed_mod, delta)
		velocity = direction * speed * speed_mod

	#hand.rotation = lerp_angle(hand.rotation, sword_dir.angle(), swing_speed * delta)
	hand.rotation = sword_dir.angle()

	move_and_slide()


func attack() -> void:
	weapon.attack()
	# Do some animation.


func shove_boxes() -> void:
	for collider in shove_zone.get_overlapping_bodies():
		if collider is Box:
			#(collider as RigidBody2D).apply_impulse(-collision.get_normal() * inertia)# * delta)
			collider.push(sword_dir)


func modify_key_count(id: int, modifer: int) -> void:
	if keys.has(id):
		keys[id] += modifer
		keys[id] = max(0, keys[id])
	elif modifer > 0:
		keys[id] = modifer

	key_count_changed.emit(id, keys[id])


func _on_weapon_attack_finished() -> void:
	stunned = false


func _on_weapon_attacked() -> void:
	stunned = true
	velocity = Vector2()
