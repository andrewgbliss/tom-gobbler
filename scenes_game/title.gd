class_name Title
extends Node
@export var scene_to_start: String
@export var start_btn: Button

func _ready() -> void:
	start_btn.grab_focus()

func _on_button_pressed():
	SceneManager.goto_scene(scene_to_start)
