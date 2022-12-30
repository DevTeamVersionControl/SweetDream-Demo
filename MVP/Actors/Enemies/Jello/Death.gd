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
	jello.animation_player.play("Death")
	yield(jello.animation_player, "animation_finished")
	if jello.volume > jello.BREAK_VOLUME:
		for n in jello.NUM_OF_BABIES:
			var new_baby = load(jello.filename).instance()
			new_baby.initial_volume = jello.volume/jello.NUM_OF_BABIES
			get_tree().current_scene.current_level.call_deferred("add_child", new_baby)
			new_baby.global_position = jello.global_position + Vector2(-5 + n*5,0)
			new_baby.target = jello.target
	jello.queue_free()
