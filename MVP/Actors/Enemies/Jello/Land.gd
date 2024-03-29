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
extends JelloEnemyState

#Handles turning around

func enter(_msg := {}) -> void:
	jello.animation_player.play("Land")
	yield(jello.animation_player, "animation_finished")
	if jello.health > 0:
		state_machine.transition_to("Idle")

func physics_process(_delta):
	jello.motion.y += jello.GRAVITY
	jello.motion.x = lerp(jello.motion.x, 0, 0.2)
	jello.motion = jello.move_and_slide(jello.motion)
