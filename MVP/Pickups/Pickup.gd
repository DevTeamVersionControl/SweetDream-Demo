extends Area2D

export var description = {"Name":"Quest Item", "Icon":"Item 3.png", "Price":"30","Unit":"artifacts", "Description":"It's that quest item another npc asked for to progress the main story"} 

var delete := false 
var save_path = GameSaver.save_path

func _ready():
	$Sprite.texture = ResourceLoader.load(description.get("Icon"))

func _on_Artifact_body_entered(body):
	if body is Player:
		GlobalVars.add_to_inventory(description)
		disappear()
		GameSaver.save()

func save(game_data):
	game_data[get_tree().current_scene.current_level.filename + name] = delete

func load(game_data):
	if game_data.has(get_tree().current_scene.current_level.filename + name):
		if game_data.get(get_tree().current_scene.current_level.filename + name):
			queue_free()

func disappear():
	delete = true
	GameSaver.save()
	GameSaver.partial_save(self)
	queue_free()
