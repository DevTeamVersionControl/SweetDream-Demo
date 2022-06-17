extends Node

onready var player = $Player

func _ready():
	if GlobalVars.door_name:
		var door_node = find_node(GlobalVars.door_name)
		if door_node:
			player.global_position = door_node.get_spawn_position()
			player.update()
