class_name TurkeyRunState
extends State

var time_to_change_direction : float = 0

func enter():
	super()
	time_to_change_direction = randf_range(2, 5)
	calculate_direction()

func process_physics(delta: float) -> State:
	parent.apply_gravity(delta)
	parent.apply_movement(delta)
	parent.move()

	if time_to_change_direction < 0:
		time_to_change_direction = randf_range(2, 5)
		calculate_direction()

	time_to_change_direction -= delta
	
	return null

func calculate_direction():
	parent.direction = Vector2(randf_range(-1, 1), 0).normalized()
