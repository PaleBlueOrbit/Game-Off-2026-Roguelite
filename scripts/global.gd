extends Node


#global variables
var max_health: int = 6
var player_health: int = max_health
var attack_cooldown: float = 1.5

signal health_changed(current: int, max_health: int)



#to be added:
var crit_change: float = 0.0
var movement_speed: float = 100.0
var max_shield: int = 0
var player_shield: int = 0
var reach: float = 100.0

func reset_game() -> void:
	player_health = max_health
	health_changed.emit(player_health, max_health) 
