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
	if input_direction_x != 0:
		player.facing_right = input_direction_x > 0
	player.camera_arm.position.x = 127 if player.facing_right else -127
	player.animation_tree.set('parameters/Run/blend_position', 1 if player.facing_right else -1)
	player.velocity.x = player.SPEED * input_direction_x
	player.velocity = player.move_and_slide_with_snap(player.velocity, Vector2.DOWN * 16, Vector2.UP, false, 4, PI/4, false)

	if Input.is_action_just_pressed("move_up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
		
	if Input.is_action_pressed("shoot") && player.can_shoot:
		state_machine.transition_to("Aim")
