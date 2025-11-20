class_name AttackSecondaryState
extends State

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if not parent.is_animation_running:
		var movement = Input.get_axis('move_left', 'move_right')
		if movement != 0:
			if Input.is_action_pressed('run'):
				return state_machine.states.get("RunState")
			else:
				return state_machine.states.get("WalkState")
		return state_machine.states.get("IdleState")
	return null
