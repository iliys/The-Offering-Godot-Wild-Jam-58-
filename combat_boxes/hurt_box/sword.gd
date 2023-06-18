class_name Sword
extends HurtBox


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_player: AudioStreamPlayer2D = $AttackSound

func attack() -> void:
	if not animation_player.is_playing() and not cooling:
		animation_player.play("attack")
		sound_player.play()
	super()
