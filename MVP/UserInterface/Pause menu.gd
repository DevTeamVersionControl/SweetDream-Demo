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

func _unhandled_input(event):
	if event.is_action_pressed("show_menu") && !event.is_echo():
		if get_tree().paused:
			print("escape unpause")
			_on_Resume_pressed()
		else:
			print("initial pause")
			get_tree().paused = true
			visible = true

func _on_Exit_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _on_Resume_pressed():
	print("resume")
	get_tree().paused = false
	visible = false

func _on_Options_pressed():
	pass # Replace with function body.
