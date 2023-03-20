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
extends Control

signal dialog_end
signal talk

onready var item_list = $ItemList
onready var description = $Description
onready var price = $Price
onready var unit = $Unit
onready var money = $Money

var save_path = GameSaver.save_path
var items
var path : String
var multiplier := 1.0

func show():
	visible = true

func start(path_to_shop:String, m_multiplier = 1.0):
	multiplier = m_multiplier
	save_path = GameSaver.save_path
	path = path_to_shop
	item_list.clear()
	show()
	GameSaver.partial_load(self)
	load_items()
	money.text = "Current:" + String(GlobalVars.artifacts)

func load_items() -> void:
	if items == null:
		default_load()
	for i in items.size():
		if items[i].has("Icon"):
			item_list.add_item(items[i]["Name"], load("res://UserInterface/Shops/Icon/"+items[i]["Icon"]))
			item_list.set_item_tooltip_enabled(i,false)
	if item_list.get_item_count() > 0:
		item_list.select(0)
		item_list.grab_focus()

func close_dialog()->void:
	if visible:
		visible = false
		get_parent().request_unpause()
		set_process_internal(false)
		emit_signal("dialog_end")

func _on_ItemList_item_selected(index):
	price.bbcode_text = String(int(int(items[index]["Price"]) * multiplier))
	unit.bbcode_text = items[index]["Unit"]
	description.bbcode_text = items[index]["Description"]

func input():
	if Input.is_action_just_pressed("ui_cancel"):
		close_dialog()
	if Input.is_action_just_pressed("ui_accept") && visible:
		if GlobalVars.artifacts >= int(items[item_list.get_selected_items()[0]]["Price"]):
			buy()

func buy():
	GlobalVars.artifacts -= int(int(items[item_list.get_selected_items()[0]]["Price"])*multiplier)
	GlobalVars.add_to_inventory(items[item_list.get_selected_items()[0]])
	items.remove(item_list.get_selected_items()[0])
	item_list.remove_item(item_list.get_selected_items()[0])
	if item_list.get_item_count() > 0:
		item_list.grab_focus()
		item_list.select(0)
		_on_ItemList_item_selected(0)
	money.text = "Current:" + String(GlobalVars.artifacts)
	GameSaver.partial_save(self)
	
func save(save_data):
	if path:
		save_data[path] = items

func load(save_data):
	if save_data.has(path):
		items = save_data[path]
	else:
		default_load()

func default_load():
	var file = File.new()
	file.open(path, File.READ)
	var json_string = file.get_as_text()
	items = parse_json(json_string)
