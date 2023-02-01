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

#Handles the third phase

const JAWBREAKER = preload("res://Actors/Enemies/Jawbreaker/Jawbreaker.tscn")


var charges := 3
var jawbreaker_array := []

func enter(_msg := {}) -> void:
	jawbreaker_boss.phase = jawbreaker_boss.PHASE.THIRD
	jawbreaker_boss.animation_player.play("ChargeToCenterRight" if jawbreaker_boss.facing_right else "ChargeToCenterLeft")
	yield(jawbreaker_boss.animation_player, "animation_finished")
	jawbreaker_boss.animation_player.play("Up")
	yield(jawbreaker_boss.animation_player, "animation_finished")
	activate()

func activate():
	#Spawns jawbreakers and permanently destroys platform
	yield(get_tree().create_timer(1.0), "timeout")
	charges -= 1
	if charges == 0:
		state_machine.transition_to("Death")
		return
		
	jawbreaker_boss.animation_player.play("Down")
	yield(jawbreaker_boss.animation_player, "animation_finished")
	
	var platform = get_tree().current_scene.current_level.get_node_or_null("BreakablePlatformMedium")
	if platform:
		get_tree().current_scene.current_level.get_node("BreakablePlatformMedium").queue_free()
	
	jawbreaker_array = []
	for i in charges:
		var jawbreaker = JAWBREAKER.instance()
		jawbreaker.initial_target_player = true
		get_tree().current_scene.current_level.add_child(jawbreaker)
		jawbreaker.global_position = Vector2((i+1)*680/5, 100)
		jawbreaker_array.append(jawbreaker.get_path())
	get_tree().current_scene.current_level.get_node("EnemyCounter").start(jawbreaker_array)
	
	jawbreaker_boss.animation_player.play("Up")
