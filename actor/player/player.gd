class_name Player
extends Actor


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = velocity.move_toward(direction * speed, dex * delta)
	move_and_slide()
