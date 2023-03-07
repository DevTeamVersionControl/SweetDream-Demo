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

var jump_buffer := false
var coyote_time := false
var input_locked := false
var double_jump := false

onready var jump_buffer_timer := $JumpBufferTimer
onready var coyote_time_timer := $CoyoteTimeTimer

# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	print("Transitioned to air")
	if msg.has("do_jump"):
		player.velocity.y = -player.JUMP_IMPULSE
	elif msg.has("coyote_time"):
		coyote_time = true
		coyote_time_timer.start()
	player.animation_tree.set('parameters/Air/blend_position', 1 if player.facing_right else -1)
	player.animation_mode.travel("Air")

func physics_update(delta: float) -> void:
	# Horizontal movement.
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	# Check to see if the player needs to turn around
	if player.facing_right != (input_direction_x > 0) && input_direction_x != 0 && !input_locked:
		lock_input(input_direction_x > 0)
	
	if input_locked:
		input_direction_x = 0
	
	#Horizontal movement
	if is_equal_approx(input_direction_x, 0.0):
		player.velocity.x = lerp(player.velocity.x, 0, player.DECELERATION)
	else:
		player.velocity.x += player.ACCELERATION * input_direction_x
	player.velocity.x = clamp(player.velocity.x, -player.SPEED, player.SPEED)

	# Vertical movement.
	player.velocity.y += player.GRAVITY * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	# Landing.
	if player.is_on_floor():
		double_jump = false
		if jump_buffer:
			state_machine.transition_to("Air", {do_jump = true})
		else:
			if is_equal_approx(player.velocity.x, 0.0):
				state_machine.transition_to("Idle")
			else:
				state_machine.transition_to("Run")
	
	# Double jump
	if Input.is_action_just_pressed("move_up") && !GlobalVars.double_jump_lock:
		if !double_jump:
			double_jump = true
			state_machine.transition_to("Air", {do_jump = true})
	
	# Dash
	if Input.is_action_pressed("dash"):
		state_machine.transition_to("Dashing")
	
	# Higher jump
	if Input.is_action_pressed("move_up") && player.velocity.y < 0:
		player.velocity.y -= player.JUMP_ACCEL * delta
	
	# Hollow knight jump
	if Input.is_action_just_released("move_up") && player.velocity.y < 0:
		player.velocity.y = 0
		
	#Coyote time
	if Input.is_action_just_pressed("move_up") && coyote_time:
		state_machine.transition_to("Air", {do_jump = true})
	
	#Jump buffering
	if Input.is_action_just_pressed("move_up") && !jump_buffer:
		jump_buffer = true
		jump_buffer_timer.start()
	
	# Player dies if out of bounds
#	if player.global_position.y > player.level_limit_max.y:
#		get_tree().current_scene.die()
	
	if Input.is_action_pressed("shoot") && player.can_shoot && GlobalVars.ammo_equipped_array.size() != 0 && GlobalVars.sugar >= GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index].sugar:
		state_machine.transition_to("Aim")

func _on_JumpBufferTimer_timeout():
	jump_buffer = false

func _on_CoyoteTimeTimer_timeout():
	coyote_time = false

func lock_input(direction : bool):
	player.facing_right = direction
	player.animation_tree.set('parameters/Air/blend_position', 1 if player.facing_right else -1)
	player.camera_arm.position.x = 127 if player.facing_right else -127
