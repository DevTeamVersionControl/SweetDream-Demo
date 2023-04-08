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

const CANDY_CORN = preload("res://Actors/Enemies/Candy Corn/CandyCornEnemy.tscn")

onready var spawn_timer := $SpawnTimer

func enter(_msg := {}) -> void:
	spawner.animation_player.play("Spawning")

func spawn() -> void:
	var candy_corn = CANDY_CORN.instance()
	candy_corn.facing_right = true
	get_tree().current_scene.current_level.add_child(candy_corn)
	candy_corn.global_position = spawner.candy_corn_spawn.global_position + Vector2.UP * 5
	candy_corn.get_node("StateMachine/Idle").on_something_detected(get_tree().current_scene.player)
	if spawner.target != null:
		spawn_timer.start()
