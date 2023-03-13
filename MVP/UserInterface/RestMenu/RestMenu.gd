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

onready var item_list = $ItemList
onready var description = $Description
onready var ammo_slots = $"Ammo Slots"

var selected_slot := 0
var items
var path : String
var inventory

func show():
	visible = true

func start(path_to_shop:String):
	path = path_to_shop
	item_list.clear()
	show()
	GameSaver.partial_load(self)
	load_items()

func load_items() -> void:
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
	description.bbcode_text = items[index]["Description"]

func input():
	if Input.is_action_just_pressed("ui_cancel"):
		close_dialog()
	if Input.is_action_just_pressed("ui_accept") && visible:
		if GlobalVars.artifacts >= int(items[item_list.get_selected_items()[0]]["Price"]):
			equip()

func equip():
	if GlobalVars.ammo_equipped_array[0] != null:
		GlobalVars.ammo_equipped_array[0] = GlobalVars.get_ammo(items[item_list.get_selected_items()[0]]["Name"])
		items.add_item(GlobalVars.ammo_equipped_array[0], load(GlobalVars.ammo_equipped_array[0]["Icon"]))
	GlobalVars.ammo_equipped_array[0] = GlobalVars.get_ammo(items[item_list.get_selected_items()[0]]["Name"])
	items.remove(item_list.get_selected_items()[0])
	item_list.remove_item(item_list.get_selected_items()[0])
	if item_list.get_item_count() > 0:
		item_list.grab_focus()
		item_list.select(0)
		_on_ItemList_item_selected(0)
