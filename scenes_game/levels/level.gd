class_name Level
extends Node

@export var next_level_path: String = ""

var cages
var cage_count = 0
var cage_broken_count = 0

func _ready():
	cages = get_tree().get_nodes_in_group("cage")
	cage_count = cages.size()
	cage_broken_count = 0
	for cage in cages:
		cage.cage_break.connect(_on_cage_break)

	call_deferred("_after_ready")

func _after_ready():
	GameUi.hud.update_enemies_killed(cage_broken_count, cage_count)
	NotifcationsToast.show_notification("Game Ready", "Ready to start the game!")
	NotifcationsToast.show_notification("Objective", "Free all the turkeys in cages!")

func _on_cage_break(pos: Vector2):
	cage_broken_count += 1
	if cage_broken_count == cage_count:
		NotifcationsToast.show_notification("Objective Complete", "You have freed all the turkeys in cages!")
		NotifcationsToast.show_notification("Next Level", "Let's go to the next level!")
		await get_tree().create_timer(10.0).timeout
		SceneManager.goto_scene(next_level_path)
	else:
		SpawnManager.float_text("%d cages left" % [cage_count - cage_broken_count], pos - Vector2(16, 24))
		GameUi.hud.update_enemies_killed(cage_broken_count, cage_count)
