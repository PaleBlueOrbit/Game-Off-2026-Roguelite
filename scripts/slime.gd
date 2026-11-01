extends Area2D

@export var damage_amount: int = 15
@export var damage_rate: float = 1.0

var player_inside: Node2D = null
var damage_timer: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Soldier" or body.is_in_group("Soldier"):
		player_inside = body
		deal_damage()

func _on_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
		damage_timer = 0.0

func _process(delta: float) -> void:
	if player_inside:
		damage_timer += delta
		if damage_timer >= damage_rate:
			deal_damage()
			damage_timer = 0.0

func deal_damage() -> void:
	if player_inside and player_inside.has_method("take_damage"):
		player_inside.take_damage(damage_amount)
