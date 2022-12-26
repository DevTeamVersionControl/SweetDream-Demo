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
extends PlayerState

func enter(msg := {}) -> void:
	yield(get_tree().create_timer(msg.get(0)), "timeout")
	if state_machine.state == self:
		state_machine.transition_to("Idle")

#func physics_update(_delta: float) -> void:
#	player.velocity.y += player.GRAVITY
#	player.velocity = player.move_and_slide(player.velocity) 
