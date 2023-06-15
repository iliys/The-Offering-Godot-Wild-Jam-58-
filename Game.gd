extends Control

@onready var gwj_logo: TextureRect = $gwj_logo
@onready var gwj_theme: TextureRect = $gwj_theme
@onready var gwj_cards: TextureRect = $gwj_cards
@onready var background: TextureRect = $background
@onready var text: Label = $text

func _ready():
	var level = preload("res://map/map2.tscn")
	$AnimationPlayer.play("logo")
	

func _process(delta):
	pass

func _input(event: InputEvent) -> void:
	$AnimationPlayer.animation_set_next("logo", "IDLE")
