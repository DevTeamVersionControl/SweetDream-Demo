extends Node

var mob = preload("res://Scenes/Enemy.tscn")

func _on_MobTimer_timeout():
	var new_mob = mob.instance()
	add_child(new_mob)
	new_mob.global_position = $Position2D.global_position
	new_mob.target = $Player
