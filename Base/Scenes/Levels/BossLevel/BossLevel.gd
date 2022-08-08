extends Node

signal on

onready var player = $Player

func _ready():
	$JawbreakerBoss.connect("activate_pillar", self, "on_pillar_activation")
	$JawbreakerBoss.connect("pillar_shake", self, "pillar_shake")
	if GlobalVars.door_name:
		var door_node = find_node(GlobalVars.door_name)
		if door_node:
			player.global_position = door_node.get_spawn_position()
			player.update()

func on_pillar_activation():
	if $Pillar/CollisionShape2D.one_way_collision:
		$Pillar/CollisionShape2D.one_way_collision = false
	else: $Pillar/CollisionShape2D.one_way_collision = true

func pillar_shake():
	$Pillar/CollisionShape2D.disabled = true
	yield(get_tree().create_timer(0.5),"timeout")
	$Pillar/CollisionShape2D.disabled = false
