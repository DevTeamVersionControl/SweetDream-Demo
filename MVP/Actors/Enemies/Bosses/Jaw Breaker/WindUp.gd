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

#Handles winding up
const DASH_SPEED = 300

func enter(_msg := {}) -> void:
	jawbreaker_boss.animation_player.play("ChargeStart")
	yield(jawbreaker_boss.animation_player, "animation_finished")
	state_machine.transition_to("Charge")

func physics_update(_delta: float) -> void:
	jawbreaker_boss.motion.y += jawbreaker_boss.gravity
	jawbreaker_boss.motion = jawbreaker_boss.move_and_slide(jawbreaker_boss.motion)

func charge():
	var tween = get_tree().create_tween()
	tween.tween_property(jawbreaker_boss, "motion", Vector2(DASH_SPEED if jawbreaker_boss.facing_right else -DASH_SPEED,0), 3.0/24.0)
