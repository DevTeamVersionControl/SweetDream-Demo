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
extends HeartState

onready var timer := $Timer

func enter(_msg := {}) -> void:
	var is_in_range := false
	for body in heart.shield_zone.get_overlapping_bodies():
		if body is Player:
			is_in_range = true
	if is_in_range:
		heart.animation_player.play("Idle")
		timer.start()
	else:
		_on_ShieldZone_body_exited(get_tree().current_scene.player)

func attack():
	if heart.target != null && state_machine.state == self:
		if heart.facing_left != ((heart.target.global_position.x - heart.global_position.x) < 0):
			heart.facing_left = true if heart.target.global_position.x - heart.global_position.x < 0 else false
			heart.scale.x *= -1
		state_machine.transition_to("Attacking")

func _on_ShieldZone_body_exited(body):
	if body == heart.target && heart.health > 0:
		if state_machine.state != self:
			yield(heart.animation_player, "animation_finished")
		state_machine.transition_to("Blocking")
