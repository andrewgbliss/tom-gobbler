class_name LandState
extends State

func enter() -> void:
	super()
	parent.landed_on_floor()	

func process_input(_event: InputEvent) -> State:
	return parent.get_input_just_pressed([
			parent.Abilities.Jump, 
			parent.Abilities.AttackPrimary, 
			parent.Abilities.AttackSecondary, 
		]
	)


func process_physics(delta: float) -> State:
	parent.apply_gravity(delta)
	parent.apply_movement(delta)
	parent.move()

	var ability_state = parent.get_input_pressed([
			parent.Abilities.Walk,
			parent.Abilities.Run,
		]
	)

	if ability_state:
		return ability_state

	if not parent.is_animation_running:
		return state_machine.states.get("IdleState")

	return null
