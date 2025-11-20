class_name PhysicsForces extends Resource

@export var max_velocity: Vector2 = Vector2(100, 100)

@export_group("Movement")
@export var walk_speed: float = 25
@export var run_speed: float = 75

@export_group("Jump")
@export var jump_force: float = -400.0

@export_group("Dash")
@export var dash_force: float = 800

@export_group("Push")
@export var push_force = 500

@export_group("Swim")
@export var swim_force = 500
