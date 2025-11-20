class_name DashState
extends State

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	return null


# @export var move_state : State
# @export var dash_time : float = .05
# @export var dash_speed : float = 800

# var dash_time_elapsed : float = 0

# func enter():
# 	dash_time_elapsed = dash_time
# 	return null

# func exit(): 
# 	return null
	
# func process_physics(delta):
	
# 	dash_time_elapsed -= delta
# 	if dash_time_elapsed <= 0:
# 		return move_state
	
# 	var speed = dash_speed
	
# 	var direction = Input.get_axis("ui_left", "ui_right")
# 	if direction:
# 		parent.velocity.x = direction * speed
# 		if parent.velocity.x < 0:
# 			parent.sprite.flip_h = true
# 		else:
# 			parent.sprite.flip_h = false
# 	else:
# 		parent.velocity.x = move_toward(parent.velocity.x, 0, speed)
		
# 	var direction_y = Input.get_axis("ui_up", "ui_down")
# 	if direction_y:
# 		parent.velocity.y = direction_y * speed
# 	else:
# 		parent.velocity.y = move_toward(parent.velocity.y, 0, speed)
		
# 	parent.move_and_slide()
	
# 	parent.position.y = clamp(parent.position.y, -120, 32)

