extends Node


#global variables
var max_health: int = 6
var player_health: int = max_health
var attack_cooldown: float = 0.75
var player_damage = 1
var crit_chance: float = 35

signal health_changed(current: int, max_health: int)
signal level_completed(next_level_file_path: String)


#to be added:
var movement_speed: float = 100.0
var max_shield: int = 0
var player_shield: int = 0
var reach: float = 100.0

func calculate_damage() -> int:
	if randf_range(0.0, 100.0) <= crit_chance:
		#print("Critical Hit!")
		return player_damage * 2.0
	else:
		return player_damage

func reset_game() -> void:
	player_health = max_health
	health_changed.emit(player_health, max_health) 
