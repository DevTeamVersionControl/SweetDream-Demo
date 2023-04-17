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

func enter(_msg := {}) -> void:
	player.velocity.x = 0
	player.animation_tree.set('parameters/Idle/blend_position', 1 if player.facing_right else -1)
	player.animation_mode.travel("Idle")
	player.camera_arm.position.x = 127 if player.facing_right else -127

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air", {coyote_time = true})
		return

	player.velocity.y += player.GRAVITY * delta
	player.velocity.x = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if !get_tree().paused:
		if Input.is_action_pressed("crouch"):
			state_machine.transition_to("Crouched")
			return
		if Input.is_action_just_pressed("move_up"):
			state_machine.transition_to("Air", {do_jump = true})
		elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			state_machine.transition_to("Run")
		elif Input.is_action_pressed("shoot") && player.can_shoot:
			if GlobalVars.ammo_equipped_array.size() != 0 && GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index] != null && GlobalVars.sugar >= GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index].sugar:
				state_machine.transition_to("Aim")
		elif Input.is_action_pressed("dash"):
			state_machine.transition_to("Dashing")
