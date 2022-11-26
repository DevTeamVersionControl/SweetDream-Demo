extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	player.animation_tree.set('parameters/Idle/blend_position', -1 if player.calculate_bullet_direction().x < 0 else 1)
	player.animation_mode.travel("Idle")

func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	if Input.is_action_just_pressed("move_up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.transition_to("Run")
	
	if Input.is_action_pressed("shoot") && player.can_shoot:
		state_machine.transition_to("Aim")
