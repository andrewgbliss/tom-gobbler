class_name Cage extends StaticBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
#@onready var turkey : Character = $Turkey

@export var cage_num : int = 0

signal cage_break

func _ready():
	animation_player.play("idle")

func die():
	animation_player.play("break")
	await animation_player.animation_finished
	cage_break.emit()
	#turkey.reparent(owner, true)
	#turkey.state_machine.change_state(turkey.state_machine.states.get("TurkeyRunState"))
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	die()

func _on_area_2d_area_entered(area: Area2D) -> void:
	die()
