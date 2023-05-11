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

var save_path = "user://MoreSettings.json"

onready var timer := $HBoxContainer/VBoxContainer3/HBoxContainer/VBoxContainer/HBoxContainer/CheckBox

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	GameSaver.partial_save(self)
	GameSaver.partial_load(self)

func input(event):
	if visible:
		if Input.is_action_pressed("ui_cancel"):
			GameSaver.partial_save(self)
			hide()
		elif Input.is_action_pressed("ui_back"):
			GameSaver.partial_save(self)
			hide()

func save(save_data):
	if is_instance_valid(timer):
		save_data["Timer"] = timer.pressed

func load(save_data):
	if save_data.has("Timer") and is_instance_valid(timer):
		timer.pressed = save_data["Timer"]

func back():
	GameSaver.partial_save(self)
	hide()
