extends Area2D

@export var damage_amount: int = 2
@export var damage_rate: float = 3.0

@onready var health_bar: ProgressBar = $HealthBar
@onready var sprite = $AnimatedSprite2D
@onready var attack_timer = $AttackTimer

var player_inside: Node2D = null
var damage_timer: float = 0.0
var max_health: int = 4
var health: int = max_health
var is_attacking: bool = false
var can_attack: bool = true
var player_in_range: bool = false

func _ready() -> void:
	body_exited.connect(_on_body_exited)
	health_bar.max_value = max_health
	health_bar.value = health
	attack_timer.wait_time = damage_rate
	attack_timer.one_shot = false
	attack_timer.autostart = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	
	
func _on_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
		damage_timer = 0.0

func _process(delta: float) -> void:
	if player_in_range and can_attack and !is_attacking:
		attack()
		
func _on_attack_timer_timeout() -> void:
	can_attack = true
	
func die() -> void:
	queue_free()

func attack() -> void:
	is_attacking = true
	can_attack = false
	sprite.offset.x = 8
	sprite.play("attack")
	await sprite.animation_finished
	sprite.speed_scale = 2.0
	sprite.play_backwards("attack")
	await sprite.animation_finished
	is_attacking = false
	sprite.speed_scale = 1
	sprite.offset.x = 0
	sprite.play("default")

func take_damage() -> void:
	health -= Global.calculate_damage()
	health = max(health, 0)
	health_bar.value = health
	
	var mat = sprite.material as ShaderMaterial
	if mat:
		print("activating shader")
		mat.set_shader_parameter("flash_modifier", 1.0)
		var tween = create_tween()
		tween.tween_property(mat, "shader_parameter/flash_modifier", 0.0, 0.15)
	else:
		print("shader error")
	
	print("slimes health = ", health)
	if health <= 0:
		die()


func _on_hurt_box_area_entered(area: Area2D) -> void:
	take_damage()


func _on_attack_area_body_entered(body: Node2D) -> void:
	player_in_range = true
	print("player in range")


func _on_attack_area_body_exited(body: Node2D) -> void:
	player_in_range = false
	print("player not in range")
