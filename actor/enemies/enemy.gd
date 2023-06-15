class_name Enemy
extends Actor


@export var wander_time_randomization := 5.0
@export var wander_range := 128.0
@export var wander_speed_factor := 0.5
@export var min_move_distance := 4.0

@onready var wander_position := global_position
@onready var detection_zone: DetectionZone = $DetectionZone
@onready var wander_timer: Timer = $WanderTimer


func _ready() -> void:
	set_physics_process(false)


func _physics_process(_delta: float) -> void:
	if not stunned:
		if detection_zone.player == null:
			wander()
		else:
			chase(detection_zone.player.global_position)

	move_and_slide()


func wander() -> void:
	_go_to_location(wander_position, wander_speed_factor)


func chase(player_pos: Vector2) -> void:
	_go_to_location(player_pos)


func _go_to_location(_location: Vector2, _speed_mod := 1.0) -> void:
	pass


func _on_wander_timer_timeout() -> void:
	wander_timer.start()
	wander_position = Vector2(randf_range(0.0, wander_range), 0.0).rotated(randf_range(-PI, PI))
