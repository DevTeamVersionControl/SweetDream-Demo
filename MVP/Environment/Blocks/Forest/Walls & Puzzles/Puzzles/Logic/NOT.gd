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

var on := true

export (NodePath) var trigger = ".."
onready var trigger_obj = get_node(trigger)

func _ready():
	if trigger_obj:
		trigger_obj.connect("on", self, "on_trigger_on")
		trigger_obj.connect("off", self, "on_trigger_off")

func on_trigger_on():
	on = false
	emit_signal("off")

func on_trigger_off():
	on = true
	emit_signal("on")
