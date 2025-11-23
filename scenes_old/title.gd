class_name Title
extends Node
@export var scene_to_start: String

func _on_button_pressed():
	SceneManager.goto_scene(scene_to_start)
