class_name WalkState
extends State

func process_input(_event: InputEvent) -> State:
	return parent.get_input_just_pressed([
			parent.Abilities.Jump, 
			parent.Abilities.AttackPrimary, 
			parent.Abilities.AttackSecondary, 
			parent.Abilities.Crouch
		]
	)

func process_physics(delta: float) -> State:
	parent.apply_gravity(delta)
	parent.apply_movement(delta)
	parent.move()

	if not parent.is_moving():
		return state_machine.states.get("IdleState")
	
	if parent.is_falling():
		return state_machine.states.get("FallState")
	
	if parent.is_pushing():
		return state_machine.states.get("PushState")

	var ability_state = parent.get_input_pressed([
			parent.Abilities.Run, 
			parent.Abilities.Crouch
		]
	)

	if ability_state:
		return ability_state

	return null
