extends Control
class_name Pause

@onready var button_return : Button = $MarginContainer/Panel/CenterContainer/VBoxContainer/ButtonReturn
@onready var button_quit : Button = $MarginContainer/Panel/CenterContainer/VBoxContainer/ButtonQuit

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("pause"):
		pause()

func _on_button_quit_pressed():
	get_tree().quit()


func _on_button_return_pressed():
	unpause()

func pause():
	show()
	button_return.grab_focus()
	get_tree().paused = true

func unpause():
	hide()
	get_tree().paused = false
