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

func enter(_msg := {}) -> void:
	jello.motion.y = -jello.JUMP_VELOCITY_Y
	jello.motion.x = jello.JUMP_VELOCITY_X if jello.facing_right else -jello.JUMP_VELOCITY_X
	jello.animation_player.play("Air")

func physics_update(delta):
	jello.motion.y += jello.GRAVITY
	var collision = jello.move_and_collide(jello.motion * delta)
	if collision && jello.health > 0:
		# Keeps it from being stuck on a ceiling
		if jello.motion.y < 0:
			jello.motion = jello.motion.bounce(collision.normal)
			collision = null
		else:
			state_machine.transition_to("Land")
	# Turn around
	if jello.facing_right == (jello.motion.x < 0):
		jello.facing_right = not jello.motion.x < 0
		jello.sprite.flip_h = !jello.facing_right
