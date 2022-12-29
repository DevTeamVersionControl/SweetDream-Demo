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
extends CandyCornState

#Handles turning around

func enter(msg := {}) -> void:
	#Turn around
	if candy_corn.facing_right == (candy_corn.target.global_position.x - candy_corn.global_position.x < 0):
		candy_corn.facing_right = false if candy_corn.target.global_position.x - candy_corn.global_position.x < 0 else true
		candy_corn.animation_player.play("Flip")
		yield(candy_corn.animation_player, "animation_finished")
		if candy_corn.health > 0:
			candy_corn.scale.x = -1
	state_machine.transition_to("Walk", msg)
