class_name PhysicsArea extends Resource

@export var name: String = ''
@export var gravity_percent: float = 1.0
@export var movement_percent: float = 1.0
@export var acceleration: float = 50.0
@export var friction: float = 70.0
@export var stop_velocity_on_enter: bool = false
@export var change_to_state: String
@export var unfreeze_area: bool = false
@export var freeze_area: bool = false
