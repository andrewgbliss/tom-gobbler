class_name FollowTargetState
extends State

@export var wander_state : State

func process_physics(delta):
	var collision = parent.move_and_collide(parent.velocity * delta)
#	if collision and not collision.get_collider().is_queued_for_deletion():
#		var collider_shape = collision.get_collider_shape()
#		var collider = collision.get_collider()
#		if collider_shape.name == 'MouthCollisionShape2D':
#			if collider.hp >= parent.hp:
#				collider.add_hp(2)
#				parent.add_hp(-1)
#		elif collider_shape.name == 'BodyCollisionShape2D':
#			collider.add_hp(-2)
#			parent.add_hp(-2)
	if had_valid_target():
		var direction = (parent.target.position - parent.position).normalized()
		parent.velocity = direction * move_speed
	else:
		return wander_state
	return null
	
func had_valid_target():
	if is_instance_valid(parent.target) and parent.target and parent.target.is_inside_tree():
		return true
	else:
		return false

#func get_distance_to_target(ctx):
#	var ant = ctx['ant']
#	var distance = ant.position.distance_to(ant.target_node.position)
#	return distance	
