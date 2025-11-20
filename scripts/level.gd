class_name Level
extends Node

@export var player : PlatformerCharacterController

var spawn_points
var cages
var cage_count = 0

func _ready():  
	spawn_points = get_tree().get_nodes_in_group("spawn_point")
	player.spawn(spawn_points[0].position)
	
	var npcs = get_tree().get_nodes_in_group("npc")
	for npc in npcs:
		npc.spawn(npc.position)
		
	var turkeys = get_tree().get_nodes_in_group("turkey")
	for turkey in turkeys:
		turkey.spawn(turkey.position)

	#cages = get_tree().get_nodes_in_group("cage")
	#cage_count = cages.size()
	#for cage in cages:
		#cage.cage_break.connect(_on_cage_break)

func _on_cage_break():
	cage_count -= 1
	if cage_count == 0:
		SceneManager.goto_next_level()
