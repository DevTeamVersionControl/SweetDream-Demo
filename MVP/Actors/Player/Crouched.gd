extends PlayerState

func enter(_msg := {}) -> void:
	print("Transitioned to crouch")
	player.velocity.x = 0
	player.animation_tree.set('parameters/Crouched/blend_position', 1 if player.facing_right else -1)
	player.animation_tree.set('parameters/Crouch/blend_position', 1 if player.facing_right else -1)
	player.animation_mode.travel("Crouched")
	player.camera_arm.position.x = 127 if player.facing_right else -127

func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	if Input.is_action_just_pressed("move_up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_pressed("shoot") && player.can_shoot:
		state_machine.transition_to("Aim", {crouched = true})
	elif !Input.is_action_pressed("aim_down"):
		state_machine.transition_to("Idle")
