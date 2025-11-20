class_name MeleeWeaponBeak extends WeaponBase

@export var beak : Area2D

var parent

func _ready() -> void:
	parent = get_parent()

func attack():
	beak.monitorable = true
	parent._play_animation(parent.animations.punch)
	await parent.animation_player.animation_finished
	beak.monitorable = false	

func can_attack():
	return true 
