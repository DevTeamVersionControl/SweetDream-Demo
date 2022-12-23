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
extends Area2D

export(String, FILE, "*tscn,*scn") var target_scene

onready var spawn_position = $Position

func _on_Portal_body_entered(body):
	if body is Player:
		if ResourceLoader.exists("res://Saves/".plus_file(target_scene.get_file())):
			get_tree().change_scene("res://Saves/".plus_file(target_scene.get_file()))
		else:
			get_tree().current_scene.play_level_transition()
			get_tree().paused = true
			yield(get_tree().current_scene.tween, "tween_completed")
			print(get_tree().change_scene(target_scene))
		GlobalVars.door_name = name

func get_spawn_position() -> Vector2:
	return spawn_position.global_position
