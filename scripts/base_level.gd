extends Node2D
class_name BaseLevel

@export_group("Replacement Tile Config")
@export var replacement_source_id: int = 0
@export var replacement_atlas_coords: Vector2i = Vector2i(0, 0)

@export_group("Level Clear Settings")
@export var tiles_to_change: Array[Vector2i] = [] # Grid coordinates to replace with a new tile

@export_file("*.tscn") var next_level_path: String


@onready var floor_layer: TileMapLayer = $Floor

var is_level_cleared: bool = false


func _ready() -> void:
	add_to_group("current_level")
	
	if has_node("Soldier") and has_node("spawn_point"):
		$Soldier.global_position = $spawn_point.global_position
	else:
		print("Soldier not found. Cannot set spawn point!!!")
	
	await get_tree().process_frame
	check_enemies()

func unlock_level() -> void:
	if has_node("SmokeParticles"):
		$SmokeParticles.emitting = true
	print("tiles to change: ", tiles_to_change)
	for coords in tiles_to_change:
		floor_layer.set_cell(coords, replacement_source_id, replacement_atlas_coords)
		print("changing cell: ", coords)
	print("Level cleared!")
	is_level_cleared = true
	
func check_enemies() -> void:
	print("Checking Enemies")
	if is_level_cleared:
		return
	if is_inside_tree():
		await get_tree().process_frame
	var remaining_enemies = get_tree().get_nodes_in_group("enemies")
	if remaining_enemies.size() == 0:
		unlock_level()

func is_target_tile(grid_pos: Vector2i) -> bool:
	return tiles_to_change.has(grid_pos)


func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("next_level"):
		print("handling next level")
		var player = find_child("Soldier", true, false)
		if player:
			print("found player")
			var player_grid_pos: Vector2i = floor_layer.local_to_map(player.global_position)
			if is_target_tile(player_grid_pos):
				if next_level_path != "":
					print("trying to load next level")
					Global.level_completed.emit(next_level_path)
				else:
					print("Game Complete! No next level specified.")
				return
