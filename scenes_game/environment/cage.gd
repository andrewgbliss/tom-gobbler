class_name Cage extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var turkey: CharacterController = $Turkey

@export var cage_num: int = 0
@export var audio_break: AudioStreamPlayer

var is_broken: bool = false

signal cage_break(pos: Vector2)

func _ready():
	animation_player.play("idle")

func die():
	if audio_break:
		audio_break.play()
	is_broken = true
	$CollisionShape2D.disabled = true
	cage_break.emit(global_position)
	animation_player.play("break")
	await animation_player.animation_finished
	turkey.reparent(owner, true)
	queue_free()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if not is_broken:
		die()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	if not is_broken:
		die()
