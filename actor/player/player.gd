# Might be good to use a state machine.
class_name Player
extends Actor


@export var attack_speed_factor := 0.0

var attacking := false

@onready var hand: Marker2D = $Hand
@onready var weapon: HurtBox = %Weapon


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	var speed_mod := attack_speed_factor if attacking else 1.0
	smooth_set_vel(direction * speed * speed_mod, delta)
	move_and_slide()

	if not attacking:
		hand.look_at(global_position + direction)


func attack() -> void:
	weapon.attack()
	# Do some animation.


func _on_weapon_attack_finished() -> void:
	attacking = false


func _on_weapon_attacked() -> void:
	attacking = true
