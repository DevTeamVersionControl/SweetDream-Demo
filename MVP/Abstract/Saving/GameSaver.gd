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

const DEFAULT_SAVE_PATH = "res://Saves/SaveData.json"

func save(save_path = DEFAULT_SAVE_PATH):
	var save_data = {}
	for node in get_tree().get_nodes_in_group("save"):
		node.save(save_data)
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error != OK:
		printerr("Could not create save file")
		return
	
	var json_string := JSON.print(save_data)
	file.store_string(json_string)
	file.close()
	
func save_scene():
	var saved_scene = PackedScene.new()
	saved_scene.pack(get_tree().current_scene)
	print(ResourceSaver.save("res://Saves/".plus_file(get_tree().get_current_scene().filename.get_file()), saved_scene))
	
func load(save_path = DEFAULT_SAVE_PATH):
	var file = File.new()
	var error = file.open(save_path, File.READ)
	if error != OK:
		printerr("Could not load save")
		return
	var json_string = file.get_as_text()
	file.close()
	var save_data : Dictionary = JSON.parse(json_string).result
	for node in get_tree().get_nodes_in_group("save"):
		node.load(save_data)
