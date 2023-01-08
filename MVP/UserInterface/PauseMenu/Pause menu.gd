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

onready var item_list := $ItemList

func _ready():
	for i in range(0,item_list.get_item_count()):
		item_list.set_item_tooltip_enabled(i,false)
	item_list.set_focus_mode(Control.FOCUS_ALL)

func input():
	if visible && !item_list.has_focus():
		print("Pause menu")
		item_list.grab_focus()
	if Input.is_action_pressed("show_menu"):
		if visible:
			resume()
		else:
			mouse_filter = Control.MOUSE_FILTER_STOP
			get_parent().request_pause()
			visible = true
			item_list.select(0)
	if Input.is_action_just_pressed("ui_accept") && visible:
		select_option()

func select_option():
	match item_list.get_item_text(item_list.get_selected_items()[0]):
		"Settings":
			get_parent().input_menu.visible = true
		"Exit":
			GameSaver.save()
			get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
		"Resume":
			resume()
	
func resume():
	if visible:
		mouse_filter = Control.MOUSE_FILTER_PASS
		get_parent().request_unpause()
		visible = false
