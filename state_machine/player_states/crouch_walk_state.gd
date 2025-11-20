class_name CrouchWalkState
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
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	var is_crouched = Input.is_action_pressed('crouch')

	if movement == 0:
		if is_crouched:
			return state_machine.states.get("CrouchIdleState")
		return state_machine.states.get("IdleState")

	if not is_crouched:
		return state_machine.states.get("WalkState")
	
	parent.sprite.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return state_machine.states.get("FallState")

	if parent.is_on_wall():
		print("Wall")

	return null
