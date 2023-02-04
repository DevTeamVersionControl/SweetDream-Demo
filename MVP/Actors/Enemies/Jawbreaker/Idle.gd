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
extends JawbreakerState

#Handles turning around

func enter(_msg := {}) -> void:
	if jawbreaker.target != null && jawbreaker.health > 0:
		activate()
	else:
		if !jawbreaker.facing_right:
			jawbreaker.facing_right = true
			turn_around()

func activate():
	if jawbreaker == null:
		yield(get_parent(), "ready")
	jawbreaker.target = get_tree().current_scene.player
	if jawbreaker.health > 0:
		if jawbreaker.facing_right == (jawbreaker.target.global_position.x - jawbreaker.global_position.x < 0):
			turn_around()
	state_machine.transition_to("WindUp")

func turn_around():
	jawbreaker.facing_right = !jawbreaker.facing_right
	jawbreaker.sprite.flip_h = !jawbreaker.facing_right
