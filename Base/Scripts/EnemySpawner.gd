extends Position2D

export var mob = preload("res://Scenes/NPCs/Enemies/JelloEnemy.tscn")
export var target_on_spawn : NodePath 
export var trigger : NodePath
export var time_between_spawn = 8.0

func _ready():
	$MobTimer.start(time_between_spawn)

func _on_MobTimer_timeout():
	if !trigger || get_node(trigger).on:
		var new_mob = mob.instance()
		get_tree().current_scene.add_child(new_mob)
		new_mob.global_position = global_position
		if target_on_spawn:
			new_mob.target = get_node(target_on_spawn)
