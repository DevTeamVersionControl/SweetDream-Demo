#MIT License
#
#Copyright (c) 2017 Nathan Lovato
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
extends Control

onready var _action_list = get_node("Column/ScrollContainer/ActionList")

func _ready():
	$InputMapper.connect('profile_changed', self, 'rebuild')
	$Column/ProfilesMenu.initialize($InputMapper)
	$InputMapper.change_profile($Column/ProfilesMenu.selected)
	GameSaver.partial_load($InputMapper)

func input(event):
	if visible:
		if $KeySelectMenu.visible:
			$KeySelectMenu.input(event)
		else:
			if Input.is_action_pressed("ui_cancel"):
				hide()
			elif Input.is_action_pressed("ui_back"):
				hide()

func rebuild(input_profile, is_customizable=false):
	_action_list.clear()
	for input_action in input_profile.keys():
		var line = _action_list.add_input_line(input_action, input_profile[input_action], is_customizable)
		if is_customizable:
			line.connect('change_button_pressed', self, \
				'_on_InputLine_change_button_pressed', [input_action, line])

func _on_InputLine_change_button_pressed(action_name, line):
	$KeySelectMenu.open()
	var key_scancode = yield($KeySelectMenu, "key_selected")
	yield(get_tree().create_timer(0.1), "timeout")
	$InputMapper.change_action_key(action_name, key_scancode)
	line.update_key(key_scancode)

func save():
	GameSaver.partial_save($InputMapper)
