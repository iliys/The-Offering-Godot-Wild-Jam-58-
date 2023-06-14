# Might be good to use a state machine.
class_name Player
extends Actor


signal max_hp_initialized(max_hp: int)
signal key_count_changed(id: int, count: int)
signal hand_updated(hand: String, icon: Texture2D)

@export var attack_speed_factor := 0.0
#@export var inertia := 128
#@export var swing_speed := 20

var attacking := false
var sword_dir := Vector2.RIGHT
var keys := {}# {id: amount}

@onready var hand: Marker2D = $Hand
@onready var tools := {R = hand.get_node("Weapon"), L = null}

@onready var shove_zone: Area2D = $ShoveZone
@onready var shove_timer: Timer = $ShoveTimer

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")


func _ready() -> void:
	max_hp_initialized.emit(max_hp)
	hp_changed.emit(hp)


func _unhandled_input(event: InputEvent) -> void:
	if stunned:
		return
	if event.is_action_pressed("attack"):
		attack()
	elif event.is_action_pressed("block") and tools.L != null:
		block()


func _physics_process(_delta: float) -> void:
	move()
	if Input.is_action_pressed("interact") and not stunned:
		shove_boxes()


func _die() -> void:
	get_tree().reload_current_scene()


@warning_ignore("shadowed_variable")
func set_tool(hand: String, to: PackedScene, icon: Texture2D) -> void:
	if tools[hand] != null:
		tools[hand].queue_free()
	var tool: Node2D = to.instantiate()
	self.hand.call_deferred("add_child", tool)
	tools[hand] = tool
	tool.activated.connect(_on_tool_activated)
	tool.finished.connect(_on_tool_finished)

	hand_updated.emit(hand, icon)


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
	shove_zone.rotation = sword_dir.angle()
	if velocity.length() > 0.0:
		playback.travel("Run")
	else:
		playback.travel("Idle")
	animation_tree.set("parameters/Idle/blend_position", sword_dir)
	animation_tree.set("parameters/Run/blend_position", sword_dir)

	move_and_slide()


func attack() -> void:
	tools.R.attack()
	# Do some animation.


func block() -> void:
	tools.L.block()


func shove_boxes() -> void:
	for collider in shove_zone.get_overlapping_bodies():
		if collider is Box:
			#(collider as RigidBody2D).apply_impulse(-collision.get_normal() * inertia)# * delta)
			if collider.push(sword_dir):
				stunned = true
				velocity = sword_dir * speed
				shove_timer.start(collider.slide_duration)


func modify_key_count(id: int, modifer: int) -> void:
	if keys.has(id):
		keys[id] += modifer
		keys[id] = max(0, keys[id])
	elif modifer > 0:
		keys[id] = modifer

	key_count_changed.emit(id, keys[id])


func _on_tool_activated() -> void:
	stunned = true
	velocity = Vector2()


func _on_tool_finished() -> void:
	stunned = false


func _on_shove_timer_timeout() -> void:
	stunned = false
