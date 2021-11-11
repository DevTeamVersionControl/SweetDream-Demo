extends Area2D

var next_level = preload("res://Scenes/Levels/Level2.tscn")


func _on_LevelSwitch_body_entered(body):
	if body.is_in_group("player"):
		if get_tree().change_scene_to(next_level):
			print("Error loading scene")
