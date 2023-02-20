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
signal shop

onready var text = $Text
onready var dialog_name = $Name
onready var timer = $Timer
onready var portrait = $TextureRect

var dialog
var phrase_num = 0
var finished = false

func input(event):
	if finished:
		next_phrase()
	elif event.pressed:
		text.visible_characters = len(text.text)

func show():
	visible = true

func start(path_to_dialog:String):
	show()
	phrase_num = 0
	finished = false
	dialog = get_dialog(path_to_dialog)
	next_phrase()
	set_process_internal(true)
	

func get_dialog(path_to_dialog:String) -> Array:
	var file = File.new()
	assert(file.file_exists(path_to_dialog), "Dialog file does not exist")
	file.open(path_to_dialog, File.READ)
	var json = file.get_as_text()
	var output = parse_json(json)
	return output if typeof(output) == TYPE_ARRAY else []

func next_phrase() -> void:
	if phrase_num >= len(dialog[0]):
		close_dialog()
		return
	
	finished = false
	
	dialog_name.bbcode_text = dialog[0][phrase_num]["Name"]
	text.bbcode_text = dialog[0][phrase_num]["Text"]
	portrait.texture = load(dialog[0][phrase_num]["Portrait"])
	if dialog[0][phrase_num].has("Signal"):
		emit_signal(dialog[0][phrase_num]["Signal"])
	
	text.visible_characters = 0
	
	while text.visible_characters < len(text.text):
		text.visible_characters += 1
		timer.start()
		yield(timer, "timeout")
	
	finished = true
	phrase_num += 1

func close_dialog()->void:
	if visible:
		visible = false
		get_parent().request_unpause()
		set_process_internal(false)
		emit_signal("dialog_end")
