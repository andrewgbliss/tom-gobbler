class_name PlatformerCharacterController extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export_group("Controls")
@export var allow_y_controls : bool = false
@export var mouse_look: bool = false

@export_group("Physics")
@export var default_physics_area: PhysicsArea
@export var physics_forces: PhysicsForces
@export var use_gravity: bool = true

@export_group("Abilities")
@export var dash_time : float = .05
@export var attack_primary: WeaponBase
@export var attack_secondary: WeaponBase

@export_group("Paths")
@export var follow_path: PathFollow2D

@export_group("Animations")
@export var animations: Dictionary[String, String] = {
	"idle": "idle",
	"walk": "walk",
	"run": "run",
	"jump": "jump",
	"jump_flip": "jump_flip",
	"fall": "fall",
	"punch": "punch",
	"kick": "kick"
}

@export_group("Character Stats")
@export var race: String
@export var class_type: String
@export_range(-1.0, 1.0) var alignment: float = 0.0
@export var stats: Dictionary[String, int] = {
	"level": 0,
	"hp": 0,
	"mp": 0,
	"xp": 0,
	"armor_rating": 0,
	"strength": 0,
	"dexterity": 0,
	"constitution": 0,
	"intelligence": 0,
	"wisdom": 0,
	"charisma": 0,
	"attack": 0
}
@export var starting_stats: Dictionary[String, int] = {
	"level": 0,
	"hp": 0,
	"mp": 0,
	"xp": 0,
	"armor_rating": 0,
	"strength": 0,
	"dexterity": 0,
	"constitution": 0,
	"intelligence": 0,
	"wisdom": 0,
	"charisma": 0,
	"attack": 0
}
@export var max_stats: Dictionary[String, int] = {
	"level": 0,
	"hp": 0,
	"mp": 0,
	"xp": 0,
	"armor_rating": 0,
	"strength": 0,
	"dexterity": 0,
	"constitution": 0,
	"intelligence": 0,
	"wisdom": 0,
	"charisma": 0,
	"attack": 0
}

var dash_time_elapsed : float = 0
var facing_right_modifier: int = 1
var is_facing_right: bool = true
var frame_velocity: Vector2
var current_physics_area: PhysicsArea
var physics_tiles: Array[PhysicsTiles] = []
var speed = 1
var target: Node2D
var previous_global_position: Vector2 = Vector2.ZERO
var follow_path_velocity
var jumps_left = 0

var is_jumping = false
var is_walking = false
var is_running = false
var is_idle = false
var is_falling = false
var is_attacking = false

signal health_changed
signal armor_changed
signal missles_changed
signal died
signal powerup
signal alignment_changed

func _ready():
	current_physics_area = default_physics_area
	for n in get_tree().current_scene.get_children():
		if n is PhysicsTiles:
			physics_tiles.append(n)
	
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed('dash') and _can_dash():
		return _apply_dash()
	if Input.is_action_just_pressed('jump') and _can_jump():
		return _apply_jump()
		
func _physics_process(delta):
	if is_on_floor(): 
		if _input_is_walking():
			speed = physics_forces.walk_speed
			is_walking = true
			is_running = false
			is_idle = false
		elif _input_is_running():
			speed = physics_forces.run_speed
			is_walking = false
			is_running = true
			is_idle = false
		else:
			is_walking = false
			is_running = false
			is_idle = true
	else:
		_apply_gravity(delta)
	#if _follow_path(delta):
		#return
	_apply_controls(delta)
	_move(delta)
	_handle_scale_flip()
	_resolve_animation()
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("attack_primary") and _can_attack_primary():
		_attack_primary()
	elif Input.is_action_pressed("attack_secondary") and _can_attack_secondary():
		_attack_secondary()

func _follow_path(delta):
	if follow_path != null:
		follow_path_velocity = (global_position - previous_global_position) / delta
		previous_global_position = global_position
		return true
	return false

func _move(delta: float):	
	velocity.y = clamp(velocity.y, -physics_forces.max_velocity.y, physics_forces.max_velocity.y)
	velocity.x = clamp(velocity.x, -physics_forces.max_velocity.x, physics_forces.max_velocity.x)

	var has_collisions = move_and_slide()

	var new_physics_area = _get_physics_area()

	if has_collisions:
		
		if is_on_floor():
			is_jumping = false
			is_falling = false
		
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			
			_resolve_collision(col)
			
			var collider = col.get_collider()
						
			# Handle collision damage from enemies
			#var collision = get_last_slide_collision()
			#var collider = collision.get_collider()
			#if collider.is_in_group("enemy"):
				#take_damage_from_node(collider)
			
			# Handle rigid bodies
			if collider is RigidBody2D:
				collider.apply_force(col.get_normal() * -physics_forces.push_force)
				
			# Handle physics tiles
			if collider is PhysicsTiles:
				if not new_physics_area and (not current_physics_area.freeze_area or collider.physics_area.unfreeze_area):
					new_physics_area = collider.physics_area
		
	# If we get a new physics area then change to it, otherwise change to the defaults
	if new_physics_area:
		_change_physics_area(new_physics_area)
	else:
		_change_physics_area(default_physics_area)

func _handle_scale_flip():
	if mouse_look:
		var mouse_pos = get_global_mouse_position()
		if mouse_pos.x < position.x:
			is_facing_right = false
			scale.x = scale.y * - facing_right_modifier
		else:
			is_facing_right = true
			scale.x = scale.y * facing_right_modifier
		return
			
#	Use velocity to determine what way is facing
	if velocity.x > 0:
		is_facing_right = true
		scale.x = scale.y * facing_right_modifier
	elif velocity.x < 0:
		is_facing_right = false
		scale.x = scale.y * - facing_right_modifier
		
func _get_facing_direction() -> Vector2:
	var direction: Vector2 = Vector2.ZERO
	direction.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	direction.y = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	return direction.normalized()

func _get_movement_direction() -> Vector2:
	return _get_movement_direction_from_keypad()
	
func _get_movement_direction_from_keypad() -> Vector2:
	var direction: Vector2 = Vector2.ZERO
	direction.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	if allow_y_controls:
		direction.y = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	return direction.normalized()
	
func _get_movement_direction_from_mouse() -> Vector2:
	var direction = get_global_mouse_position() - global_position
	return direction.normalized()
	
func _get_aim_direction():
	if mouse_look:
		return _get_movement_direction_from_mouse()
	var input : Vector2 = Vector2.ZERO
	input.x = (Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"))
	input.y = (Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up"))
	return input.normalized()
	
func _input_is_walking() -> bool:
	return not Input.is_action_pressed("run") and _get_movement_direction() != Vector2.ZERO

func _input_is_running() -> bool:
	return Input.is_action_pressed("run") and _get_movement_direction() != Vector2.ZERO
		
func _is_action_just_pressed(action_name) -> bool:
	return Input.is_action_just_pressed(action_name)

func _is_action_pressed(action_name) -> bool:
	return Input.is_action_pressed(action_name)
	
func _is_movement_pressed() -> bool:
	if allow_y_controls:
		return _is_action_pressed("move_left") or _is_action_pressed("move_right") or _is_action_pressed("move_up") or _is_action_pressed("move_down")
	return _is_action_pressed("move_left") or _is_action_pressed("move_right")	
	
func _is_attacking():
	return Input.is_action_pressed("attack_primary") or Input.is_action_pressed("attack_secondary")

func _is_falling():
	return velocity.y > 0 and not is_on_floor()
	
func _apply_gravity(delta: float):
	if use_gravity:
		velocity += (get_gravity() * current_physics_area.gravity_percent) * delta
	if velocity.y > 0:
		is_jumping = false
		is_falling = true
			
func _apply_controls(delta: float):
	var direction = _get_movement_direction()
	
	#if direction != Vector2.ZERO:
		#velocity = velocity.move_toward(direction * speed * current_physics_area.movement_percent, current_physics_area.acceleration)
	#else:
		#velocity = velocity.move_toward(Vector2.ZERO, current_physics_area.friction)
	
	if direction.x != 0:
		velocity.x = move_toward(velocity.x, direction.x * speed * current_physics_area.movement_percent, current_physics_area.acceleration)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, current_physics_area.friction)
						
func _change_physics_area(physics_area: PhysicsArea):
	if current_physics_area.freeze_area and not physics_area.unfreeze_area:
		return false
	if physics_area != current_physics_area:
		#print("Change physics", physics_area.name)
		current_physics_area = physics_area
		#if state_machine != null and state_machine.states != null and current_physics_area.change_to_state:
			#state_machine.change_state(state_machine.states.get(current_physics_area.change_to_state))
		if current_physics_area.stop_velocity_on_enter:
			velocity = Vector2.ZERO
		return true
	return false

func _get_physics_area() -> PhysicsArea:
	for physics_tilemap in physics_tiles:
		var tile_pos = physics_tilemap.local_to_map(position)
		var data = physics_tilemap.get_cell_tile_data(tile_pos)
		if data:
			return physics_tilemap.physics_area
	return null
	
func _resolve_collision(collision):
	var normal = collision.get_normal()
	var depth = collision.get_depth()
	var travel = collision.get_travel()

	# Calculate the movement needed to resolve the collision
	var move_amount = normal * depth

	# Adjust position considering the original travel direction (optional)
	global_position += move_amount + (travel * 0.1)  # Adjust the factor as needed
	
func _apply_dash():
	dash_time_elapsed = dash_time
	var direction
	if mouse_look:
		direction =  _get_movement_direction_from_mouse()
	else:
		direction =  _get_movement_direction()
	velocity += direction * physics_forces.dash_force * current_physics_area.movement_percent

func _can_dash():
	return true
	
func _dash_state(delta):
	dash_time_elapsed -= delta
	# if dash_time_elapsed <= 0:
		#return move_state
		
func spawn(pos):
	if sprite.material != null:
		sprite.material.set_shader_parameter("color", Color.WHITE)
	position = pos
	velocity = Vector2.ZERO
	#is_alive = true
	#is_paralyzed = false
	show()

func _die():
	hide()
	#is_alive = false
	#is_paralyzed = true

func _take_damage(damage: int):
	#hp -= damage
	#if hp <= 0:
		#_die()
	pass
	
func _take_damage_blink_red(amount):
	# If there is armor, take it from there
	if stats.armor > 0:
		stats.armor -= stats.amount
		armor_changed.emit()
		return
	
	stats.hp -= stats.amount

	# Check for death
	if stats.hp <= 0:
		health_changed.emit()
		_die()
		return
	
	# Emit current health
	health_changed.emit()

	if stats.hp < max_stats.hp * .25:
		_health_blink_red()

func _health_blink_red():
	sprite.material.set_shader_parameter("color", Color(100, 1, 1, 1))
	get_tree().create_timer(.5).timeout.connect(_health_blink_normal)

func _health_blink_normal():
	sprite.material.set_shader_parameter("color", Color.WHITE)
	if stats.hp < max_stats.hp * .25:
		get_tree().create_timer(.5).timeout.connect(_health_blink_red)

func _take_damage_from_node(actor):
	_take_damage(actor.attack)

signal on_alignment_change(alignment: float)

func _reset_stats():
	stats = starting_stats

func _set_alignment(value: float):
	alignment = clamp(value, -1.0, 1.0)
	on_alignment_change.emit(alignment)

func _change_alignment(value: float):
	_set_alignment(alignment + value)

func _is_good():
	return alignment > 0.3

func _is_evil():
	return alignment < - 0.3

func _is_neutral():
	return alignment >= - 0.3 and alignment <= 0.3

func _get_heat_stars():
	if alignment >= 0:
		return ""
	elif alignment >= - 0.25:
		return "*"
	elif alignment >= - 0.5:
		return "**"
	elif alignment >= - 0.75:
		return "***"
	elif alignment >= - 1:
		return "****"

func _get_heat() -> int:
	if alignment >= 0:
		return 0
	elif alignment >= - 0.25:
		return 1
	elif alignment >= - 0.5:
		return 2
	elif alignment >= - 0.75:
		return 3
	elif alignment >= - 1:
		return 4
	return 0

func _on_pickup(_coords: Vector2, items: Array[Item]):
	pass
	#if inventory == null:
		#return
	#for item in items:
		#if item is Ammo:
			#inventory.missles += item.quantity
			#missles_changed.emit(inventory.missles)

func _on_consume(_coords: Vector2, items: Array[Consumable]):
	for item in items:
		stats.hp += item.health
		stats.armor += item.armor
		
		if stats.hp > max_stats.hp:
			stats.hp = max_stats.hp
		if stats.armor > max_stats.armor:
			stats.armor = max_stats.armor

		health_changed.emit()
		armor_changed.emit()

		#if item.level == 1:
			#GameManager.game_data.level += 1
			#powerup.emit()

func _get_distance_from_target():
	if target == null:
		return 0
	return global_position.distance_to(target.global_position)

func _apply_jump():
	jumps_left = jumps_left - 1
	velocity.y = -physics_forces.jump_force
	is_jumping = true
	is_falling = false
	if is_running:
		_play_animation(animations.jump_flip)
	else:
		_play_animation(animations.jump)
	
func _can_jump():
	return true

func _resolve_animation():
	if is_attacking or is_jumping:
		return
	elif is_falling:
		_play_animation(animations.fall)
	elif is_running:
		_play_animation(animations.run)
	elif is_walking:
		_play_animation(animations.walk)
	else:
		_play_animation(animations.idle)

func _play_animation(animation_name: String):
	if animation_player.current_animation != animation_name:
		#print("STATE", animation_name)
		animation_player.play(animation_name)

func _can_attack_primary():
	return attack_primary.can_attack()

func _attack_primary():
	if attack_primary.can_attack():
		is_attacking = true
		await attack_primary.attack()
		is_attacking = false
	
func _can_attack_secondary():
	return attack_secondary.can_attack()
	
func _attack_secondary():
	if attack_secondary.can_attack():
		is_attacking = true
		await attack_secondary.attack()
		is_attacking = false
