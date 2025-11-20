class_name StateMachine
extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func init(parent) -> void:
	for child in get_children():
		child.parent = parent
		child.state_machine = self
		states[child.name] = child
	if initial_state:
		change_state(initial_state)
		
func change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
		
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
