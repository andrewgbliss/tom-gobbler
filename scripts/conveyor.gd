extends Sprite2D

@export var reset : Vector2 = Vector2(500, 0)
@export var movement : Vector2 = Vector2(0, 0)

var start : Vector2
var reset_pos : Vector2

func _ready():
	start = position	
	reset_pos = start + reset

func _process(delta):
	translate(Vector2(movement.x, 0))

	if position.x >= reset_pos.x:
		position = start - reset
