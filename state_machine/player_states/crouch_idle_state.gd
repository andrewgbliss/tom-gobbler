class_name CrouchIdleState
extends State

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return state_machine.states.get("JumpState")
	if Input.is_action_pressed('run') and parent.is_on_floor() and parent.velocity.x != 0:
		return state_machine.states.get("RunState")
	if Input.is_action_just_pressed('punch'):
		return state_machine.states.get("AttackPrimaryState")
	if Input.is_action_just_pressed('kick'):
		return state_machine.states.get("AttackSecondaryState")
	if Input.is_action_pressed('crouch'):
		if Input.is_action_pressed('move_left') or Input.is_action_pressed('move_right'):
			return state_machine.states.get("CrouchWalkState")
	return null

func process_physics(_delta: float) -> State:

	if not Input.is_action_pressed('crouch'):
		return state_machine.states.get("IdleState")

	return null
