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
extends BushState

func enter(_msg := {}) -> void:
	if (bush.facing_left):
		bush.animation_player.play("IdleLeft")
	else:
		bush.animation_player.play("IdleRight")

func attack():
	if bush.target != null:
		bush.facing_left = true if bush.target.global_position.x - bush.global_position.x < 0 else false
		state_machine.transition_to("Attacking")
	else:
		state_machine.transition_to("Asleep", {0:"From attack"})
