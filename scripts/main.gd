extends Node2D

@export_file("*.tscn") var next_scene_path: String

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if next_scene_path != "":
			get_tree().change_scene_to_file(next_scene_path)
		else:
			print("Warning: No next scene path assigned!")
