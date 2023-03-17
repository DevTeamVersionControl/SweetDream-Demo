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
extends Node

signal profile_changed(new_profile, is_customizable)

var save_path := "user://InputProfiles.json"

var current_profile_id := 0
var profiles = {
	0: {"Name":"normal", "customizable":false},
	1: {"Name":"custom", "customizable":true},
}
var normal = {
	'move_up': KEY_Z,
	'crouch': KEY_DOWN,
	'move_left': KEY_LEFT,
	'move_right': KEY_RIGHT,
	'shoot': KEY_X,
	'ammo_next' : KEY_C,
	'dash' : KEY_V,
	'ui_accept' : KEY_ENTER,
	'ui_cancel' : KEY_ESCAPE,
	'ui_back' : KEY_X,
	'delete' : KEY_DELETE
}
var custom = normal

func change_profile(id):
	current_profile_id = id
	var profile = get(profiles[id].get("Name"))
	var is_customizable = profiles[id].get("customizable")
	
	for action_name in profile.keys():
		change_action_key(action_name, profile[action_name])
	emit_signal('profile_changed', profile, is_customizable)
	return profile

func change_action_key(action_name, key_scancode):
	erase_action_events(action_name)

	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	InputMap.action_add_event(action_name, new_event)
	get_selected_profile()[action_name] = key_scancode

func erase_action_events(action_name):
	var input_events = InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)

func get_selected_profile():
	return get(profiles[current_profile_id].Name)

func _on_ProfilesMenu_item_selected(ID):
	change_profile(ID)

func save(save_data):
	save_data["current_profile"] = current_profile_id
	save_data["custom"] = custom

func load(save_data):
	custom = save_data["custom"]
	change_profile(int(save_data["current_profile"]))
