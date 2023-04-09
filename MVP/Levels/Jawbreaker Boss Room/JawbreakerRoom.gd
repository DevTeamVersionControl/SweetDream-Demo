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

export var level_range_x : Vector2
export var level_range_y : Vector2

func _ready():
	yield(get_tree().current_scene, "level_loaded")
	$JawbreakerBoss.connect("died", self, "on_died")

func on_died():
	var tween = get_tree().create_tween()
	tween.tween_property($AudioStreamPlayer, "volume_db", -80.0, 5.0)
	tween.tween_callback(self, "end")

func end():
	get_tree().current_scene.start_dialog("res://Levels/FirstLevel/Railroad.json", 1)
