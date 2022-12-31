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
extends Node

signal on
signal off

var on := false

export (NodePath) var input_path1 = ".."
export (NodePath) var input_path2
onready var input_obj1 = get_node(input_path1)
onready var input_obj2 = get_node(input_path2)

func _ready():
	if input_obj1 && input_obj2:
		input_obj1.connect("on", self, "on_trigger_on1")
		input_obj1.connect("off", self, "on_trigger_off2")
		input_obj2.connect("on", self, "on_trigger_on1")
		input_obj2.connect("off", self, "on_trigger_off2")

func on_trigger_on1():
	on = true
	emit_signal("on")

func on_trigger_on2():
	on = true
	emit_signal("on")

func on_trigger_off1():
	if input_obj2.on:
		on = true
		emit_signal("on")
	else:
		emit_signal("off")
	
func on_trigger_off2():
	if input_obj1.on:
		on = true
		emit_signal("on")
	else:
		emit_signal("off")
