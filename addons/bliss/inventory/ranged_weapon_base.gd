class_name RangedWeaponBase extends Node2D

@export var ranged_weapon : RangedWeapon

var fire_rate_time_elapsed : float = 0.0
var cooldown = false

func _process(delta: float) -> void:
	fire_rate_time_elapsed += delta
	if fire_rate_time_elapsed <= ranged_weapon.fire_rate:
		cooldown = true
	else:
		cooldown = false

func attack():
	fire_rate_time_elapsed = 0
	var b = ranged_weapon.projectile.instantiate()
	var mouse_pos = get_global_mouse_position()
	var dir = mouse_pos - global_position
	#var dir = parent.controls.get_aim_direction() - parent.global_position
	b.start(global_position, dir)
	get_tree().get_root().add_child(b)

func can_attack():
	return !cooldown
