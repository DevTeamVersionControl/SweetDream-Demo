extends Area2D

export(String, FILE, "*tscn,*scn") var target_scene

onready var spawn_position = $Position

func _on_Portal_body_entered(body):
	if body is Player:
		if ResourceLoader.exists("res://Saves/".plus_file(target_scene.get_file())):
			get_tree().change_scene("res://Saves/".plus_file(target_scene.get_file()))
		else:
			print(get_tree().change_scene(target_scene))
		GlobalVars.door_name = name

func get_spawn_position() -> Vector2:
	return spawn_position.global_position
