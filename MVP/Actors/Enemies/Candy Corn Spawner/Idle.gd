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
extends SpawnerState

func enter(_msg := {}) -> void:
	spawner.animation_player.play("Idle")

func activate():
	var is_in_range := false
	for body in spawner.player_detector.get_overlapping_bodies():
		if body is Player:
			is_in_range = true
	if not is_in_range:
		get_parent().get_parent()._on_something_leave(get_tree().current_scene.player)
	state_machine.transition_to("Spawning")
