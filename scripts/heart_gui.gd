extends Control

@onready var sprite: TextureRect = $HeartSprite # Use TextureRect if you changed it, or Sprite2D if it's still a sprite

# Double check that these file paths perfectly match your FileSystem folders!
@export var full_heart_tex: Texture2D = preload("res://assets/hearts/ui_heart_full.png")
@export var half_heart_tex: Texture2D = preload("res://assets/hearts/ui_heart_half.png")
@export var empty_heart_tex: Texture2D = preload("res://assets/hearts/ui_heart_empty.png") 

func update_heart(state: int) -> void:
	match state:
		0: sprite.texture = empty_heart_tex
		1: sprite.texture = half_heart_tex
		2: sprite.texture = full_heart_tex
