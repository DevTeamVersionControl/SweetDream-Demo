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

var items
var path : String

func show():
	visible = true

func start(path_to_shop:String):
	path = path_to_shop
	item_list.clear()
	show()
	items = get_items()
	load_items()
	money.text = "Current:" + String(GlobalVars.artifacts)

func get_items() -> Array:
	var file = File.new()
	assert(file.file_exists(path), "Dialog file does not exist")
	file.open(path, File.READ)
	var json = file.get_as_text()
	var output = parse_json(json)
	return output if typeof(output) == TYPE_ARRAY else []

func load_items() -> void:
	for i in items.size():
		if items[i].has("Icon"):
			item_list.add_item(items[i]["Name"], load("res://UserInterface/Shops/Icon/"+items[i]["Icon"]))
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
	price.bbcode_text = items[index]["Price"]
	unit.bbcode_text = items[index]["Unit"]
	description.bbcode_text = items[index]["Description"]

func input():
	if Input.is_action_just_pressed("ui_cancel"):
		close_dialog()
	if Input.is_action_just_pressed("ui_accept") && visible:
		if GlobalVars.artifacts >= int(items[item_list.get_selected_items()[0]]["Price"]):
			buy()

func buy():
	GlobalVars.artifacts -= int(items[item_list.get_selected_items()[0]]["Price"])
	GlobalVars.add_to_inventory(items[item_list.get_selected_items()[0]])
	items.remove(item_list.get_selected_items()[0])
	item_list.remove_item(item_list.get_selected_items()[0])
	if item_list.get_item_count() > 0:
		item_list.grab_focus()
		item_list.select(0)
		_on_ItemList_item_selected(0)
	money.text = "Current:" + String(GlobalVars.artifacts)
	GameSaver.save()
	
func save(save_data):
	if path:
		save_data[path] = items

func load(save_data):
	if save_data.has(path):
		items = save_data[path]
