class_name FallState
extends State

func process_input(_event: InputEvent) -> State:
	return parent.get_input_just_pressed([
			parent.Abilities.Jump, 
			parent.Abilities.JumpFlip,
			parent.Abilities.AttackPrimary, 
			parent.Abilities.AttackSecondary
		]
	)

func process_physics(delta: float) -> State:
	parent.apply_gravity(delta)
	parent.apply_movement(delta)
	parent.move()
	
	if parent.is_on_floor():
		return state_machine.states.get("LandState")

	return null
