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

const ATTACK = preload("res://Actors/Enemies/Candy Corn/Candy Corn Attack.wav")

func enter(_msg := {}) -> void:
	if candy_corn.health > 0:
		candy_corn.animation_player.play("StopWalk")
	yield(candy_corn.animation_player, "animation_finished")
	if candy_corn.health > 0:
		candy_corn.animation_player.play("Attack", -1, 1.5, false)
	yield(candy_corn.animation_player, "animation_finished")
	if candy_corn.health > 0:
		state_machine.transition_to("Idle")

func on_hit_something(something):
	if something is Player:
		something.take_damage(candy_corn.ATTACK_DAMAGE, Vector2(candy_corn.KNOCKBACK if candy_corn.facing_right else -candy_corn.KNOCKBACK, 0))

func play_attack():
	candy_corn.audio_stream_player.stream = ATTACK
	candy_corn.audio_stream_player.play()

func _physics_process(delta):
	candy_corn.motion.x = 0
	candy_corn.motion.y += 8
	candy_corn.motion = candy_corn.move_and_slide(candy_corn.motion)
