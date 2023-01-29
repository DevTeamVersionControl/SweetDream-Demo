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
var touching_wall = false

func enter(msg := {}) -> void:
	jawbreaker_boss.animation_player.play("Idle")
	if jawbreaker_boss.phase == jawbreaker_boss.PHASE.SECOND:
		touching_wall = false
		for body in jawbreaker_boss.wall_sensor.get_overlapping_areas():
			if body.is_in_group("wall"):
				touching_wall = true
		activate()
		if msg.has("initial_charge"):
			jawbreaker_boss.facing_right = !jawbreaker_boss.facing_right
			jawbreaker_boss.sprite.flip_h = !jawbreaker_boss.facing_right

func activate():
	if jawbreaker_boss.facing_right == (get_tree().current_scene.player.global_position.x - jawbreaker_boss.sprite.global_position.x < 0):
		jawbreaker_boss.facing_right = !(get_tree().current_scene.player.global_position.x - jawbreaker_boss.sprite.global_position.x < 0)
		jawbreaker_boss.sprite.flip_h = !jawbreaker_boss.facing_right
	if jawbreaker_boss.should_transition == true:
		state_machine.transition_to("Phase3")
		return
	if touching_wall:
		if state_machine.state.name != "Shooting":
			state_machine.transition_to("Shooting")
	else:
		state_machine.transition_to("WindUp")
