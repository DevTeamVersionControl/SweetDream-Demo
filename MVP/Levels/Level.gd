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
	GameSaver.load()
#	if get_node_or_null("AudioStreamPlayer") != null:
#		var tween = get_tree().create_tween().tween_property($AudioStreamPlayer, "volume_db", 0.0, 20.0)

func _on_Button_on():
	$TileMap.set_cell(5,8,-1)
	$TileMap.set_cell(5,9,-1)
	$TileMap.set_cell(6,8,-1)
	$TileMap.set_cell(6,9,-1)
	$TileMap.update_bitmask_area(Vector2(6,9))
	$TileMap.update_bitmask_area(Vector2(5,8))
	$TileMap.update_bitmask_area(Vector2(5,9))
	if get_node_or_null("DarkZone2"):
		$DarkZone2.disappear()

func on_jawbreaker_pickup(body):
	if body is Player:
		var tween = get_tree().create_tween()
		tween.tween_property($AudioStreamPlayer2D4, "volume_db", -80.0, 10.0)
		tween.tween_callback(self, "end")
		tween = get_tree().create_tween()
		tween.tween_property($AudioStreamPlayer2D3, "volume_db", -80.0, 10.0)
		tween.tween_callback(self, "end")
		tween = get_tree().create_tween()
		tween.tween_property($AudioStreamPlayer2D2, "volume_db", -80.0, 10.0)
		tween.tween_callback(self, "end")
		tween = get_tree().create_tween()
		tween.tween_property($AudioStreamPlayer2D5, "volume_db", -80.0, 10.0)
		tween.tween_callback(self, "end")
