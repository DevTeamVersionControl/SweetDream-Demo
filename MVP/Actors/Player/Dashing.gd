extends PlayerState

#Handles dashing
const DASH_SPEED = 1600
const DASH_TIME = 0.1

var can_dash := true

onready var dash_reset_timer = $DashResetTimer
onready var dash_length_timer = $DashLengthTimer

func enter(_msg := {}) -> void:
	if can_dash:
		player.velocity.y = 0
		can_dash = false
		player.animation_tree.set('parameters/Dash/blend_position', 1 if player.facing_right else -1)
		player.animation_mode.travel("Dash")
		player.velocity.x = DASH_SPEED if player.facing_right else -DASH_SPEED
		dash_reset_timer.start()
		dash_length_timer.start(DASH_TIME)
	else:
		state_machine.transition_to("Air")

func physics_update(delta: float) -> void:
	var collision = player.move_and_collide(player.velocity * delta)
	if collision != null:
		on_impact(collision.normal)

func on_impact(normal):
	player.velocity = player.velocity.bounce(normal)
	player.velocity *= 0.8

func on_can_dash():
	can_dash = true

func on_dash_end():
	state_machine.transition_to("Air")
