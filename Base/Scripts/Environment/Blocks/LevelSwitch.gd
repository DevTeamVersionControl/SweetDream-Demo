extends Area2D

export(String, FILE, "*tscn,*scn") var target_scene
var num:int

func _on_LevelSwitch_body_entered(body):
	if body.is_in_group("player"):
		if get_tree().change_scene(target_scene):
			print("Error loading scene")
		GlobalVars.door_name = name
		
func get_spawn_position() -> Vector2:
	return $Position2D.global_position
