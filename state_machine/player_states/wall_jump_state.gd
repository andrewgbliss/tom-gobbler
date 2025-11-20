class_name WallJumpState
extends State

func enter() -> void:
	super()
	parent.apply_jump()	
	
func process_input(_event: InputEvent) -> State:
	return parent.get_input_just_pressed([
		parent.Abilities.AttackPrimary, 
		parent.Abilities.AttackSecondary, 
			parent.Abilities.Jump,
			parent.Abilities.JumpFlip,
		]
	)

func process_physics(delta: float) -> State:
	parent.apply_gravity(delta * parent.wall_friction)
	parent.apply_movement(delta)
	parent.move()
	
	if parent.is_wall_clinging():	
		return state_machine.states.get("WalkClingState")

	if not parent.is_animation_running and parent.is_falling():
		return state_machine.states.get("FallState")
	
	if parent.is_idle():
		return state_machine.states.get("IdleState")
	
	return null
