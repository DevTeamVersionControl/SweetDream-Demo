extends PlayerState

var jump_buffer := false
var coyote_time := false
onready var jump_buffer_timer := $JumpBufferTimer
onready var coyote_time_timer := $CoyoteTimeTimer

# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = -player.JUMP_IMPULSE
	elif msg.has("coyote_time"):
		coyote_time = true
		coyote_time_timer.start()
	player.animation_mode.travel("Air")
	player.run = false
	player.idle = false
	player.air = true

func physics_update(delta: float) -> void:
	# Horizontal movement.
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	player.velocity.x = player.SPEED * input_direction_x
	# Vertical movement.
	player.velocity.y += player.GRAVITY * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	# Landing.
	if player.is_on_floor():
		if jump_buffer:
			state_machine.transition_to("Air", {do_jump = true})
		else:
			if is_equal_approx(player.velocity.x, 0.0):
				state_machine.transition_to("Idle")
			else:
				state_machine.transition_to("Run")
	
	# Higher jump
	if Input.is_action_pressed("move_up") && player.velocity.y < 0:
		player.velocity.y -= player.JUMP_ACCEL * delta
		
	#Coyote time
	if Input.is_action_just_pressed("move_up") && coyote_time:
		state_machine.transition_to("Air", {do_jump = true})
	#Jump buffering
	if Input.is_action_just_pressed("move_up") && !jump_buffer:
		jump_buffer = true
		jump_buffer_timer.start()
	
	if player.global_position.y > player.level_limit.y:
		print(get_tree().reload_current_scene())
	
	if Input.is_action_pressed("shoot") && player.can_shoot:
		player.bullet_direction = player.calculate_bullet_direction()
		if player.held_ammo:
			player.held_ammo.shoot()
		else:
			#player.shooting = true
			player.animation_mode.travel("ShootAir")
			player.animation_tree.set('parameters/ShootAir/blend_position', player.bullet_direction)
			player.animation_tree.set('parameters/Idle/blend_position', -1 if player.bullet_direction.x < 0 else 1)
			player.animation_tree.set('parameters/Air/blend_position', -1 if player.bullet_direction.x < 0 else 1)


func _on_JumpBufferTimer_timeout():
	jump_buffer = false


func _on_CoyoteTimeTimer_timeout():
	coyote_time = false
