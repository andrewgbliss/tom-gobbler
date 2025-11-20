class_name TurkeyFlapState
extends State

func process_physics(delta: float) -> State:
	parent.apply_gravity(delta)
	parent.move()

	return null
