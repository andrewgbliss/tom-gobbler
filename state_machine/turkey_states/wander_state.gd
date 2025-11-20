class_name WanderState
extends State

@export var follow_target_state : State
@export var target_group : String
@export var argo_distance : float = 25

var direction : Vector2
var time_to_change_direction : float = 0

func enter() -> void:
	super()
	time_to_change_direction = randf_range(2, 5)
	calculate_direction()
	
func process_physics(delta):
	parent.velocity = direction * move_speed
	var collision = parent.move_and_collide(parent.velocity * delta)
	if collision:
		calculate_direction()
	if time_to_change_direction < 0:
		time_to_change_direction = randf_range(2, 5)
		calculate_direction()
	if detect_target():
		return follow_target_state
	time_to_change_direction -= delta
	return null

func calculate_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func detect_target() -> bool: 
	var targets = get_tree().get_nodes_in_group(target_group)
	for other in targets:
		if other == parent:
			continue
		var distance = parent.position.distance_to(other.position)
		if distance < argo_distance:
			parent.target = other
			return true
	return false
