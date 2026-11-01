extends Node2D

func _ready() -> void:
	if has_node("Soldier") and has_node("spawn_point"):
		$Soldier.global_position = $spawn_point.global_position
	else:
		print("Soldier not found. Cannot set spawn point!!!")
