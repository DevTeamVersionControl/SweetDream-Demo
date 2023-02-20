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
extends CanvasLayer

onready var color_rect = $LevelTransition/ColorRect
onready var dialog = $Dialog
onready var shop = $Shop
onready var pause_menu = $PauseMenu
onready var input_menu := $InputMenu

var pause_requests := 0

func _unhandled_input(event):
	if shop.visible:
		shop.input()
	elif dialog.visible:
		dialog.input(event)
	elif input_menu.visible:
		input_menu.input(event)
	else:
		pause_menu.input()

func request_pause():
	get_tree().paused = true
	pause_requests += 1

func request_unpause():
	pause_requests -= 1
	if pause_requests == 0:
		get_tree().paused = false
