extends Node

onready var SaveData = load("res://Abstract/Saves/SaveData.gd")

func save():
	var save_data = SaveData.new()
	for node in get_tree().get_nodes_in_group("save"):
		node.save(save_data)
	print(ResourceSaver.save("res://Abstract/Saves/SaveData.tres", save_data))
	
func save_scene():
	var saved_scene = PackedScene.new()
	saved_scene.pack(get_tree().current_scene)
	print(ResourceSaver.save("res://Abstract/Saves/".plus_file(get_tree().get_current_scene().filename.get_file()), saved_scene))
	
func load():
	if ResourceLoader.exists("res://Save/SaveData.tres"):
		var save_data : Resource = ResourceLoader.load("res://Abstract/Saves/SaveData.tres")
		for node in get_tree().get_nodes_in_group("save"):
			node.load(save_data)
