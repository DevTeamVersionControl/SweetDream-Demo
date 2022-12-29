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
	jello.animation_player.play("Idle")
	if jello.target != null:
		activate()

func activate() -> void:
	if jello.hp > 0:
		turn_around()
		if !jello.stuck:
			state_machine.transition_to("Jump")

func on_something_detected(something) -> void:
	if something is Player && jello.target == null:
		jello.target = something
		activate()

func turn_around() -> void:
	if jello.facing_right == (jello.target.global_position.x - jello.global_position.x < 0):
		jello.facing_right = false if jello.target.global_position.x - jello.global_position.x < 0 else true
		jello.sprite.flip_h = !jello.facing_right
		jello.stuck = false
		activate()
		
func physics_update(_delta:float) -> void:
	if jello.stuck:
		turn_around()
