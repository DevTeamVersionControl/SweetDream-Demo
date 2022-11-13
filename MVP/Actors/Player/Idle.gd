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
		player.bullet_direction = player.calculate_bullet_direction()
		if player.held_ammo:
			player.held_ammo.shoot()
		else:
			#player.shooting = true
			player.animation_mode.travel("ShootIdle")
			player.animation_tree.set('parameters/ShootIdle/blend_position', player.bullet_direction + Vector2(0.1 if player.facing_right else -0.1, 0))
			player.animation_tree.set('parameters/Idle/blend_position', 1 if player.facing_right else -1)
			player.animation_tree.set('parameters/Run/blend_position', 1 if player.facing_right else -1)
