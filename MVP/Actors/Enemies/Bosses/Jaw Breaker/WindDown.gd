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
extends JawbreakerBossState

#Handles turning around

func enter(_msg := {}) -> void:
	if jawbreaker_boss.health > 0:
		jawbreaker_boss.animation_player.play("ChargeEnd")
		var tween = get_tree().create_tween()
		tween.tween_property(jawbreaker_boss, "motion", Vector2(0,0), 0.5)
	yield(jawbreaker_boss.animation_player, "animation_finished")
	if jawbreaker_boss.health > 0:
		state_machine.transition_to("Idle")

func physics_update(_delta: float) -> void:
	jawbreaker_boss.motion.y += jawbreaker_boss.gravity
	jawbreaker_boss.motion = jawbreaker_boss.move_and_slide(jawbreaker_boss.motion)
