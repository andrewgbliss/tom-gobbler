class_name IdleState
extends State

func enter() -> void:
	super()
	parent.velocity.x = 0	

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
	parent.move()

	if parent.is_falling():
		return state_machine.states.get("FallState")

	var ability_state = parent.get_input_pressed([
			parent.Abilities.Walk, 
			parent.Abilities.Run, 
			parent.Abilities.Crouch
		]
	)

	if ability_state:
		return ability_state

	return null
