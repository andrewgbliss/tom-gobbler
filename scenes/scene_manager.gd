extends CanvasLayer

@onready var color : ColorRect = $ColorRect
@onready var label : Label = $Label
@onready var animation_player : AnimationPlayer = $AnimationPlayer

var current_scene = null
var level = 0

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	color.hide()
	label.hide()

func fade_in():
	color.show()
	label.show()
	animation_player.play("FadeIn")
	await animation_player.animation_finished
	
func fade_out():
	animation_player.play("FadeOut")
	await animation_player.animation_finished
	color.hide()
	label.hide()
	
	
func goto_next_level():

	level += 1

	# print("level", level)

	var level_scene = "res://levels/level_%d.tscn" % level
	label.text = "Level %d" % level

	if level > 5:
		level_scene = "res://scenes/title.tscn"
		label.text = "You have set all the turtles free! Thanks for playing!"
	
	var path = level_scene
	
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	await fade_in()

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	
	fade_out()
