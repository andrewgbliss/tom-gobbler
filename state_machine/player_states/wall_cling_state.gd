class_name WallClingState
extends State

func process_input(_event: InputEvent) -> State:
	return parent.get_input_just_pressed([
			parent.Abilities.AttackPrimary, 
			parent.Abilities.AttackSecondary, 
			parent.Abilities.WallJump,
		]
	)

func process_physics(delta: float) -> State:
	parent.apply_gravity(delta * parent.wall_friction)
	parent.apply_movement(delta)
	parent.move()
	
	if parent.is_idle():
		return state_machine.states.get("IdleState")
	
	if parent.is_falling():
		return state_machine.states.get("FallState")

	# if is_on_wall:	
	# 	if movement != 0:
	# 		# Need to check if wall on left and pushing left = ok
	# 		# Need to check if wall on left and pushing right = not ok
	# 		# Need to check if wall on right and pushing right = ok
	# 		# Need to check if wall on right and pushing left = not ok
	# 		return null
	
	return null
