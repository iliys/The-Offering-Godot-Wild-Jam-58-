class_name Sword
extends HurtBox


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func attack() -> void:
	if not animation_player.is_playing() and not cooling:
		animation_player.play("attack")
	super()
