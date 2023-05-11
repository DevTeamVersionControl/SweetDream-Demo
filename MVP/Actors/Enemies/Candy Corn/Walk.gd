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
extends CandyCornState

#Handles when the candy corn is idle

func enter(msg := {}) -> void:
	if !msg.has("from_walk"):
		candy_corn.animation_player.play("StartWalk")
		yield(candy_corn.animation_player, "animation_finished")
	if candy_corn.health > 0:
		candy_corn.animation_player.play("Walk")

func physics_update(_delta):
	if candy_corn.health > 0:
		candy_corn.motion.x = candy_corn.SPEED if candy_corn.facing_right else -candy_corn.SPEED
		candy_corn.motion.y += 8
		candy_corn.motion = candy_corn.move_and_slide(candy_corn.motion)
		if candy_corn.facing_right == (candy_corn.target.global_position.x - candy_corn.global_position.x < 0):
			state_machine.transition_to("TurnAround", {from_walk = true})
		elif (candy_corn.global_position.x - candy_corn.target.global_position.x) < 20 && (candy_corn.global_position.x - candy_corn.target.global_position.x) > -20:
			state_machine.transition_to("Attack")

func play_walk():
	candy_corn.audio_stream_player.stream = candy_corn.WALK
	candy_corn.audio_stream_player.play()
