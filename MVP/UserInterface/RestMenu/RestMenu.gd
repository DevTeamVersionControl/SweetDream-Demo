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
var items : Array

func show():
	visible = true

func start():
	items = GlobalVars.inventory
	item_list.clear()
	if GlobalVars.ammo_equipped_array.size() != 2:
		GlobalVars.ammo_equipped_array.clear()
		GlobalVars.ammo_equipped_array.resize(2)
	show()
	load_items()
	load_slots()
	

func load_slots() -> void:
	#Temporary restriction since you don't change gun in the demo
	for children in ammo_slots.get_children():
		children.queue_free()
	for i in 2:
		var icon = TextureRect.new()
		icon.expand = true
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		icon.set_custom_minimum_size(Vector2(70,70))
		if (i < GlobalVars.ammo_equipped_array.size() && GlobalVars.ammo_equipped_array[i] != null):
			icon.texture = load(GlobalVars.get_from_inventory(GlobalVars.ammo_equipped_array[i].name)["Icon"])
		else:
			icon.texture = load("res://UserInterface/RestMenu/EmptySlot.png")
		ammo_slots.add_child(icon)

func load_items() -> void:
	for i in GlobalVars.inventory.size():
		if GlobalVars.inventory[i].has("Icon") && GlobalVars.inventory[i].has("Ammo"):
			item_list.add_item(GlobalVars.inventory[i]["Name"], load(GlobalVars.inventory[i]["Icon"]))
			item_list.set_item_tooltip_enabled(i,false)
		else:
			items.remove(i)
	if item_list.get_item_count() > 0:
		item_list.select(0)
		item_list.grab_focus()

func close_dialog() -> void:
	if visible:
		get_tree().current_scene.player.update_display()
		visible = false
		get_parent().request_unpause()
		set_process_internal(false)
		emit_signal("dialog_end")

func _on_ItemList_item_selected(index):
	description.bbcode_text = items[index]["Description"]

func input() -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close_dialog()
	if Input.is_action_just_pressed("ui_accept") && visible:
		equip()

func equip() -> void:
	# Remove previous instance of the same object
	if GlobalVars.ammo_equipped_array.has(GlobalVars.get_ammo(items[item_list.get_selected_items()[0]]["Name"])):
		GlobalVars.ammo_equipped_array[GlobalVars.ammo_equipped_array.find(GlobalVars.get_ammo(items[item_list.get_selected_items()[0]]["Name"]))] = null
	# Put the new item in the slot
	GlobalVars.ammo_equipped_array[selected_slot] = GlobalVars.get_ammo(items[item_list.get_selected_items()[0]]["Name"])
	# Advance selected slot
	selected_slot = (selected_slot+1)%2
	if item_list.get_item_count() > 0:
		item_list.grab_focus()
		item_list.select(0)
		_on_ItemList_item_selected(0)
	load_slots()
