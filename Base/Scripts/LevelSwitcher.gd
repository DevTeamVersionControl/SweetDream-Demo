extends Node

export var default_level:PackedScene
var current_level

func _ready():
	current_level = default_level.instance()
	current_level.connect("change_level", self, "change_level")
	add_child(current_level)

func change_level(scene:PackedScene, num:int):
	var next_level = scene.instance()
	next_level.connect("change_level", self, "change_level")
	current_level.queue_free()
	current_level = next_level
