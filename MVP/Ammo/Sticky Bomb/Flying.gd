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
extends StickyBombState

func enter(_msg := {}) -> void:
	sticky_bomb.explosion_timer.start()
	sticky_bomb.animation_player.play("Flying")

func physics_update(delta: float) -> void:
	sticky_bomb.velocity.y += sticky_bomb.GRAVITY * delta
	var collision = sticky_bomb.move_and_collide(sticky_bomb.velocity*delta, false)
	if collision != null:
		state_machine.transition_to("Stuck")
