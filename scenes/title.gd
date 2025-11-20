class_name Title
extends Node

@onready var start_button : Button = $ButtonStart

@export var player : Character

var spawn_points

func _ready():  
	spawn_points = get_tree().get_nodes_in_group("spawn_point")
	#player.spawn(spawn_points[0].position)

	start_button.grab_focus()

	SceneManager.level = 0

func _on_button_pressed():
	SceneManager.goto_next_level()
