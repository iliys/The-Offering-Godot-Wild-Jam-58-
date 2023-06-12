class_name Enemy
extends Actor


@export var wander_time_randomization := 5.0
@export var wander_range := 128.0
@export var wander_speed_factor := 0.5
@export var min_move_distance := 4.0

@onready var wander_position := global_position
@onready var detection_zone: DetectionZone = $DetectionZone
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@onready var wander_timer: Timer = $WanderTimer


func _ready() -> void:
	navigation_agent.max_speed = speed


func _physics_process(delta: float) -> void:
	if stunned:
		move_and_slide()
	else:
		if detection_zone.player == null:
			wander(delta)
		else:
			chase(detection_zone.player.global_position, delta)


func wander(delta: float) -> void:
	go_to_localtion(wander_position, delta, wander_speed_factor)


func chase(player_pos: Vector2, delta: float) -> void:
	go_to_localtion(player_pos, delta)


func go_to_localtion(location: Vector2, delta: float, speed_mod := 1.0) -> void:
	navigation_agent.target_position = location
	var next_path_pos := navigation_agent.get_next_path_position()
	if global_position.distance_to(next_path_pos) >= min_move_distance:
		var direction := global_position.direction_to(next_path_pos)
		#smooth_set_vel(direction * speed * speed_mod, delta)
		velocity = direction * speed * speed_mod
	else:
		#smooth_set_vel(Vector2(), delta)
		velocity = Vector2()

	navigation_agent.set_velocity(velocity)


func _on_wander_timer_timeout() -> void:
	wander_timer.start()
	wander_position = Vector2(randf_range(0.0, wander_range), 0.0).rotated(randf_range(-PI, PI))


func _on_navigation_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
