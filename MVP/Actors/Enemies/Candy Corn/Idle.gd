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

#Handles when the candy corn is idle

func enter(_msg := {}) -> void:
	candy_corn.animation_player.play("Idle")
	if candy_corn.target != null:
		activate()

func on_something_detected(something):
	if something is Player:
		candy_corn.target = something
		activate()

func activate():
	if candy_corn.health > 0:
		state_machine.transition_to("TurnAround")
