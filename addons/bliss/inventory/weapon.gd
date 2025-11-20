class_name Weapon extends Equipable

@export var crit_percent: float = 0.0

@export_group("Weapon Modifiers")
@export var damage_modifiers = {
	"fire": 0,
	"acid": 0,
	"lightning": 0,
	"ice": 0,
	"poison": 0
}
