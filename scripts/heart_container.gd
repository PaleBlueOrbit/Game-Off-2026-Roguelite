extends HBoxContainer

# Drag your heart_gui.tscn file into this slot in the Inspector
@export var heart_template: PackedScene 

func _ready() -> void:
	Global.health_changed.connect(update_hearts)
	update_hearts(Global.player_health, Global.max_health)

func update_hearts(current_health: int, max_health: int) -> void:
	for child in get_children():
		child.queue_free()
		
	var total_slots: int = max_health / 2
	
	for i in range(total_slots):
		var new_heart = heart_template.instantiate()
		add_child(new_heart)
		
		var heart_value = clampi(current_health - (i * 2), 0, 2)
		new_heart.update_heart(heart_value)
