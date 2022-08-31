extends Node

onready var SaveData = load("res://Save/Logic/SaveData.gd")

func save():
	var save_data = SaveData.new()
	for node in get_tree().get_nodes_in_group("save"):
		node.save(save_data)
	ResourceSaver.save("res://Save/SaveData.tres", save_data)
	
func save_scene():
	var saved_scene = PackedScene.new()
	saved_scene.pack(get_tree().current_scene)
	ResourceSaver.save("res://Save/".plus_file(get_tree().get_current_scene().filename.get_file()), saved_scene)
	
func load():
	if ResourceLoader.exists("res://Save/SaveData.tres"):
		var save_data : Resource = ResourceLoader.load("res://Save/SaveData.tres")
		for node in get_tree().get_nodes_in_group("save"):
			node.load(save_data)
