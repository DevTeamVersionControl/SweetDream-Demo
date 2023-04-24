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

var save_path = "user://SoundSettings.json"

onready var master_volume := $HBoxContainer/VBoxContainer3/HBoxContainer/VBoxContainer2/HBoxContainer/HSlider
onready var music_volume := $HBoxContainer/VBoxContainer3/HBoxContainer/VBoxContainer2/HBoxContainer3/HSlider
onready var effects_volume := $HBoxContainer/VBoxContainer3/HBoxContainer/VBoxContainer2/HBoxContainer4/HSlider

func _ready():
	GameSaver.partial_load(self)
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
	save_data["Master"] = master_volume.value
	save_data["Music"] =  music_volume.value
	save_data["SoundEffects"] =  effects_volume.value

func load(save_data):
	master_volume.value = save_data["Master"]
	music_volume.value = save_data["Music"]
	effects_volume.value = save_data["SoundEffects"] 
	set_volume(null)

func back():
	GameSaver.partial_save(self)
	hide()

func set_volume(_dummy):
	AudioServer.set_bus_volume_db(0, linear2db(float(master_volume.value)/100))
	AudioServer.set_bus_volume_db(1, linear2db(float(music_volume.value)/100))
	AudioServer.set_bus_volume_db(2, linear2db(float(effects_volume.value)/100))
