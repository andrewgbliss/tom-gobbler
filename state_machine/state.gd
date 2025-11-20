class_name State
extends Node

@export var animation_name: String
@export var move_speed: float = 400

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var parent : Character
var state_machine : StateMachine

signal state_enter
signal state_exit

func enter() -> void:
	state_enter.emit()
	parent.animation_player.play(animation_name)

func exit() -> void:
	state_exit.emit()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null
	
func process_physics(_delta: float) -> State:
	return null
