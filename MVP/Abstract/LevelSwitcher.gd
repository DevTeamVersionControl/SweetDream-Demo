# Sweet Dream, a sweet metroidvannia
#    Copyright (C) 2022 Kamran Charles Nayebi and William Duplain
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
extends Node2D

const PLAYER = preload("res://Actors/Player/Player.tscn")

onready var tween = $LevelTransition/ColorRect/Tween
onready var level_transition = $LevelTransition/ColorRect

export var first_level = preload("res://Levels/FirstLevel.tscn")

var current_level : Node2D
var next_level : PackedScene
var checkpoint = GlobalTypes.Checkpoint.new("Checkpoint",first_level)
var door_location : String
var player : Player

func _ready():
	load_level(first_level, "")

func change_level(new_level:PackedScene, portal_name:String):
	tween.interpolate_property(level_transition, "self_modulate",
		Color(0, 0, 0, 0), Color(0, 0, 0, 1), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	get_tree().paused = true
	next_level = new_level
	door_location = portal_name

func _on_animation_finished(_object, _key):
	if next_level != null:
		load_level(next_level, door_location)
		get_tree().paused = false

func load_level(level:PackedScene, location:String):
	if current_level != null:
		current_level.queue_free()
	current_level = level.instance()
	add_child(current_level)
	player = PLAYER.instance()
	player.level_limit_min = Vector2(current_level.level_range_x.x, current_level.level_range_y.x)
	player.level_limit_max = Vector2(current_level.level_range_x.y, current_level.level_range_y.y)
	current_level.add_child(player)
	if location != "":
		var door_node = current_level.find_node(location)
		if door_node:
			player.camera.smoothing_enabled = false
			player.global_position = door_node.get_spawn_position()
			player.update()
	player.level_limit_min = Vector2(current_level.level_range_x.x, current_level.level_range_y.x)
	player.level_limit_max = Vector2(current_level.level_range_x.y, current_level.level_range_y.y)
	tween.interpolate_property(level_transition, "self_modulate",
		Color(0, 0, 0, 1), Color(0, 0, 0, 0), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	next_level = null

func die():
	next_level = checkpoint.level
	GlobalVars.hp = 100
	call_deferred("load_level", next_level, checkpoint.name)

func set_checkpoint(new_checkpoint):
	checkpoint = new_checkpoint
