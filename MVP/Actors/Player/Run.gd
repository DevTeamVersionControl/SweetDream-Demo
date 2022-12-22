extends PlayerState

func enter(_msg := {}) -> void:
	player.animation_tree.set('parameters/Run/blend_position', 1 if player.facing_right else -1)
	player.animation_mode.travel("Run")

func physics_update(_delta: float) -> void:
	# Notice how we have some code duplication between states. That's inherent to the pattern,
	# although in production, your states will tend to be more complex and duplicate code
	# much more rare.
	if not player.is_on_floor():
		state_machine.transition_to("Air", {coyote_time = true})
		return

	# We move the run-specific input code to the state.
	# A good alternative would be to define a `get_input_direction()` function on the `Player.gd`
	# script to avoid duplicating these lines in every script.
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	# Check to see if the player jumped
	if Input.is_action_just_pressed("move_up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_equal_approx(player.velocity.x, 0.0) && is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("aim_down"):
		if player.facing_right:
			player.animation_player.play("CrouchRight")
		else:
			player.animation_player.play("CrouchLeft")
		yield(player.animation_player, "animation_finished")
		player.animation_player.play("RESET")
		state_machine.transition_to("Idle")
	
	# Check to see if the player needs to turn around
	if player.facing_right != (input_direction_x > 0) && input_direction_x != 0:
		if player.facing_right:
			player.animation_player.play("TurnLeft")
		else:
			player.animation_player.play("TurnRight")
		yield(player.animation_player, "animation_finished")
		player.facing_right = input_direction_x > 0
		player.animation_tree.set('parameters/Run/blend_position', 1 if player.facing_right else -1)
		player.animation_tree.set('parameters/Idle/blend_position', 1 if player.facing_right else -1)
		player.camera_arm.position.x = 127 if player.facing_right else -127
	
	if is_equal_approx(input_direction_x, 0.0):
		player.velocity.x = lerp(player.velocity.x, 0, player.DECELERATION)
	else:
		player.velocity.x += player.ACCELERATION * input_direction_x
	player.velocity.x = clamp(player.velocity.x, -player.SPEED, player.SPEED)
	player.velocity = player.move_and_slide_with_snap(player.velocity, Vector2.DOWN * 16, Vector2.UP, false, 4, PI/4, false)
	
	if Input.is_action_pressed("shoot") && player.can_shoot:
		state_machine.transition_to("Aim")
