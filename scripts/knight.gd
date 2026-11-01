extends CharacterBody2D

@export var speed: float = 60.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	print("Level loaded! Current Player Health: ", Global.player_health)

func take_damage(amount: int) -> void:
	Global.player_health -= amount
	print("You took ", amount, "damage", "  New Health: ", Global.player_health)
	
	Global.health_changed.emit(Global.player_health, Global.max_health)
	if Global.player_health <= 0:
		die()
		
func die() -> void:
	print("You Died")
	Global.reset_game()
	get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false

	if direction != Vector2.ZERO:
		sprite.play("run")
	else:
		sprite.play("idle")
