class_name MeleeWeaponKick extends WeaponBase

@export var kick : Area2D

var parent

func _ready() -> void:
	parent = get_parent()

func attack():
	kick.monitorable = true
	parent._play_animation(parent.animations.kick)
	await parent.animation_player.animation_finished
	kick.monitorable = false	

func can_attack():
	return true 
