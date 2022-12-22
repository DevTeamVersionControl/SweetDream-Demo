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

onready var SaveData = load("res://Abstract/Saves/SaveData.gd")

func save():
	var save_data = SaveData.new()
	for node in get_tree().get_nodes_in_group("save"):
		node.save(save_data)
	print(ResourceSaver.save("res://Abstract/Saves/SaveData.tres", save_data))
	
func save_scene():
	var saved_scene = PackedScene.new()
	saved_scene.pack(get_tree().current_scene)
	print(ResourceSaver.save("res://Abstract/Saves/".plus_file(get_tree().get_current_scene().filename.get_file()), saved_scene))
	
func load():
	if ResourceLoader.exists("res://Save/SaveData.tres"):
		var save_data : Resource = ResourceLoader.load("res://Abstract/Saves/SaveData.tres")
		for node in get_tree().get_nodes_in_group("save"):
			node.load(save_data)
