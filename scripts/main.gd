extends Node2D

@export_file("*.tscn") var next_scene_path: String

var current_level: Node = null

func _ready() -> void:
	Global.level_completed.connect(_on_level_completed)
	current_level = $Level1
	randomize()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		if next_scene_path != "":
			get_tree().change_scene_to_file(next_scene_path)
		else:
			print("Warning: No next scene path assigned!")
				

func _on_level_completed(next_path: String) -> void:
	if next_path != "":
		get_tree().change_scene_to_file(next_scene_path)
	else:
		print("No next level path specified. Game Complete!")
