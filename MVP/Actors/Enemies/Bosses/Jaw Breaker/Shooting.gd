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

const PROJECTILE = preload("res://Actors/Enemies/Bosses/Jaw Breaker/JawbreakerBossProjectile.tscn")
const SPEED = 400
const HEIGHTS = [-50, 0, 50]

func enter(_msg := {}) -> void:
	jawbreaker_boss.animation_player.play("Idle")
	for i in 5:
		if jawbreaker_boss.should_transition == true:
			state_machine.transition_to("Phase3")
			return
		shoot()
		jawbreaker_boss.audio_stream_player.stream = jawbreaker_boss.SHOOT
		jawbreaker_boss.audio_stream_player.play()
		yield(get_tree().create_timer(0.6), "timeout")
	yield(get_tree().create_timer(1), "timeout")
	if jawbreaker_boss.should_transition == true:
		state_machine.transition_to("Phase3")
		return
	state_machine.transition_to("WindUp")

func physics_update(_delta: float) -> void:
	jawbreaker_boss.motion.x = 0
	jawbreaker_boss.motion.y += jawbreaker_boss.gravity
	jawbreaker_boss.motion = jawbreaker_boss.move_and_slide(jawbreaker_boss.motion)

func shoot():
	var projectile = PROJECTILE.instance()
	projectile.motion = Vector2.RIGHT if jawbreaker_boss.facing_right else Vector2.LEFT
	projectile.motion *= SPEED
	get_tree().current_scene.current_level.add_child(projectile)
	projectile.global_position = jawbreaker_boss.sprite.global_position + projectile.motion.normalized() * 100
	projectile.global_position.y += HEIGHTS[randi()%HEIGHTS.size()]
