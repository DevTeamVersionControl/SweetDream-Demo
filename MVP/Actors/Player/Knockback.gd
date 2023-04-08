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
extends PlayerState

#Handles knockback

var knockback_recovery := 0.05
var gravity_scale := 0.5

func enter(msg := {}) -> void:
	if msg.get(0) != null:
		player.velocity = msg.get(0)
		get_tree().current_scene.shaker.start(0.2, 5, msg.get(0).length()/100)

func physics_update(delta: float) -> void:
	player.velocity.x = lerp(player.velocity.x, 0, knockback_recovery)
	player.velocity.y += player.GRAVITY * delta * gravity_scale
	player.velocity = player.move_and_slide(player.velocity)
	if player.velocity.x < 100 && player.velocity.x > -100:
		if player.is_on_floor():
				state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Air")
