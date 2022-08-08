extends Node

signal on
signal off

export(Array, NodePath) var enemies
var on := false
var num : int

func _ready():
	for enemy in enemies:
		get_node(enemy).connect("died", self, "on_enemy_died")
	num = enemies.size()

func on_enemy_died():
	num = num-1
	if num == 0:
		emit_signal("on")
		on = true
