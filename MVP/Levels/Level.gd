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
extends Node

onready var player = $Player
onready var tween = $LevelTransition/ColorRect/Tween
onready var level_transition = $LevelTransition/ColorRect
export var level_range_x = Vector2(0, 1100)
export var level_range_y = Vector2(0, 1920)

func _ready():
	if GlobalVars.door_name:
		var door_node = find_node(GlobalVars.door_name)
		if door_node:
			player.camera.smoothing_enabled = false
			player.global_position = door_node.get_spawn_position()
			player.update()
	player.level_limit_min = Vector2(level_range_x.x, level_range_y.x)
	player.level_limit_max = Vector2(level_range_x.y, level_range_y.y)
	tween.interpolate_property(level_transition, "self_modulate",
		Color(0, 0, 0, 1), Color(0, 0, 0, 0), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	get_tree().paused = false

func play_level_transition():
	tween.interpolate_property(level_transition, "self_modulate",
		Color(0, 0, 0, 0), Color(0, 0, 0, 1), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
