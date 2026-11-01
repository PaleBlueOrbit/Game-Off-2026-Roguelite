extends CharacterBody2D

@export var speed: float = 60.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer

var is_dead: bool = false
var is_attacking: bool = false
var can_attack:bool = true

func _ready() -> void:
	print("Level loaded! Current Player Health: ", Global.player_health)
	attack_timer.wait_time = Global.attack_cooldown
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	
func take_damage(amount: int) -> void:
	if is_dead:
		return
	
	Global.player_health -= amount
	print("You took ", amount, "damage", "  New Health: ", Global.player_health)
	
	Global.health_changed.emit(Global.player_health, Global.max_health)
	if Global.player_health <= 0:
		die()
		
func die() -> void:
	print("You Died")
	is_dead = true
	velocity = Vector2.ZERO
	
	sprite.play("die")
	await sprite.animation_finished
	Global.reset_game()
	get_tree().reload_current_scene()

func attack() -> void:
	can_attack = false
	attack_timer.start()
	is_attacking = true
	sprite.play("sword_side")
	await sprite.animation_finished
	is_attacking = false
	
func _on_attack_timer_timeout() -> void:
	can_attack = true
	print("Ready to attack again!")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and can_attack:
		attack()

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
	
	if !is_attacking:
		if direction != Vector2.ZERO:
			sprite.play("run")
		else:
			sprite.play("idle")
