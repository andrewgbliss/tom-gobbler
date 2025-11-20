class_name Character
extends CharacterBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var state_machine = $StateMachine
@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

@export_category("Character Physics")
@export var move_speed: float = 400
@export var run_modifier: float = 1.5
@export var jumps: int = 1
@export var jump_force: float = 900.0
@export var wall_friction: float = 0.9
@export var push_force: float = 80.0

@export_category("AI")
@export var ai: bool = false

var jumps_left = 0
var is_animation_running : bool = false
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement : float = 0
var direction : Vector2 = Vector2(1, 0)
var facing_direction : float = 1

enum Abilities {
	Walk,
	Run,
	Jump,
	JumpFlip,
	AttackPrimary,
	AttackSecondary,
	Crouch,
	WallJump
}

func _ready():
	hide()
	state_machine.init(self)
	animation_player.animation_started.connect(_on_animation_started)
	animation_player.animation_finished.connect(_on_animation_finished)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
		
func _on_animation_started(_anim_name: StringName):
	is_animation_running = true
	
func _on_animation_finished(_anim_name: StringName):
	is_animation_running = false
	
func spawn(pos):
	position = pos
	show()

func apply_gravity(delta: float):
	velocity.y += gravity * delta

func apply_movement(_delta: float):
	movement = get_movement()

	if movement != 0:
		change_dir(sign(movement))

	var speed = movement * move_speed

	if is_running() or is_jump_flipping():
		speed = speed * run_modifier

	velocity.x = speed

func change_dir(dir: float):
	if dir != facing_direction:
		facing_direction = dir
		scale.x = -1

func apply_jump():
	jumps_left = jumps_left - 1
	velocity.y = -jump_force

func move():
	move_and_slide()

func get_movement():
	if ai:
		return get_ai_movement()
	else:
		return get_input_movement()
	
func get_ai_movement():
	return direction.x

func get_input_movement():
	return Input.get_axis('move_left', 'move_right')

func is_idle():
	return is_on_floor() and not is_moving() and not is_on_wall()

func is_moving():
	return movement != 0

func is_wall_clinging():
	return false
	# return is_on_wall() and is_moving()

func is_falling():
	return velocity.y > 0 and !is_on_floor() and !is_wall_clinging()

func is_pushing_idle():
	return false
	# return is_on_floor() and is_on_wall()

func is_pushing():
	return false
	# return is_on_floor() and is_on_wall() and is_moving()

func is_running():
	return state_machine.current_state == state_machine.states.get("RunState")

func is_jump_flipping():
	return state_machine.current_state == state_machine.states.get("JumpFlipState")

func landed_on_floor():
	jumps_left = jumps

func can_jump():
	if is_on_floor() and jumps_left <= 0:
		jumps_left = jumps
	return jumps_left > 0

func get_input_just_pressed(abilities: Array[Abilities]) -> State:

	if Abilities.Jump in abilities:
		if Input.is_action_just_pressed('jump') and can_jump():
			if Abilities.JumpFlip in abilities and is_moving():
				return state_machine.states.get("JumpFlipState")
			return state_machine.states.get("JumpState")
	
	if Abilities.AttackPrimary in abilities:
		if Input.is_action_just_pressed('attack_primary'):
			return state_machine.states.get("AttackPrimaryState")

	if Abilities.AttackSecondary in abilities:
		if Input.is_action_just_pressed('attack_secondary'):
			return state_machine.states.get("AttackSecondaryState")

	if Abilities.Crouch in abilities:
		if Input.is_action_just_pressed('crouch'):
				if not is_moving():
					return state_machine.states.get("CrouchIdleState")
				else:
					return state_machine.states.get("CrouchWalkState")

	if Abilities.WallJump in abilities:
		if Input.is_action_just_pressed('jump') and is_on_wall():
			return state_machine.states.get("WallJumpState")

	return null

func get_input_pressed(abilities: Array[Abilities]) -> State:

	if Abilities.Run in abilities:
		if (Input.is_action_pressed('move_left') or Input.is_action_pressed('move_right')) and Input.is_action_pressed('run'):
			if is_on_floor():	
				return state_machine.states.get("RunState")

	if Abilities.Walk in abilities:
		if (Input.is_action_pressed('move_left') or Input.is_action_pressed('move_right')) and not Input.is_action_pressed('run'):
			if is_on_floor():
				return state_machine.states.get("WalkState")

	if Abilities.Crouch in abilities:
		if Input.is_action_pressed('crouch'):
				if not is_moving():
					return state_machine.states.get("CrouchIdleState")
				else:
					return state_machine.states.get("CrouchWalkState")

	return null
