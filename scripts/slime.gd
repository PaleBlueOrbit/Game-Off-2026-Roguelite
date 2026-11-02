extends Area2D

@export var damage_amount: int = 15
@export var damage_rate: float = 1.0

@onready var health_bar: ProgressBar = $HealthBar
@onready var sprite = $AnimatedSprite2D

var player_inside: Node2D = null
var damage_timer: float = 0.0
var max_health: int = 4
var health: int = max_health

func _ready() -> void:
	body_exited.connect(_on_body_exited)
	health_bar.max_value = max_health
	health_bar.value = health
	
func _on_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
		damage_timer = 0.0

func _process(delta: float) -> void:
	pass
		
func die() -> void:
	queue_free()

func take_damage() -> void:
	health -= Global.calculate_damage()
	health = max(health, 0)
	health_bar.value = health
	
	var mat = sprite.material as ShaderMaterial
	if mat:
		var tween = create_tween()
		mat.set_shader_parameter("flash_modifier", 1.0)
		tween.tween_property(mat, "shader_parameter/flash_modifier", 0.0, 0.15)
	
	print("slimes health = ", health)
	if health <= 0:
		die()


func _on_hurt_box_area_entered(area: Area2D) -> void:
	take_damage()
