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

var loaded_scene

onready var thread := Thread.new()
onready var spawn_position = $Position

func _ready():
	thread.start(self, "load_level", target_scene)

func _on_Portal_body_entered(body):
	if body is Player:
		if thread.is_alive():
			thread.wait_to_finish()
		get_tree().current_scene.change_level(load(target_scene), name)

func get_spawn_position() -> Vector2:
	return spawn_position.global_position

func load_level(m_target_scene:String):
	loaded_scene = load(m_target_scene)

func _exit_tree():
	thread.wait_to_finish()
