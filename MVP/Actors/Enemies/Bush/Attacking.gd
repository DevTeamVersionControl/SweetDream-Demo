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

var grabbed := false

func enter(_msg := {}) -> void:
	if bush.facing_left:
		bush.animation_player.play("AttackLeft")
	else:
		bush.animation_player.play("AttackRight")

func grabbed_something(something):
	if something is Player:
		something.take_damage(bush.GRAB_DAMAGE, Vector2.ZERO)
		something.knock_out(bush.animation_player.current_animation_length - bush.animation_player.current_animation_position)
		grabbed = true
		yield(bush.animation_player, "animation_finished")
		grabbed = false

func hit_something(something):
	if something is Player:
		something.take_damage(bush.WAVE_DAMAGE, Vector2(bush.WAVE_STRENGTH * (-1 if bush.facing_left else 1), -50))

func physics_update(_delta: float) -> void:
	if grabbed:
		bush.target.global_position = bush.grab_position.global_position
