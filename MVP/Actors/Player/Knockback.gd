extends PlayerState

#Handles knockback

var knockback_recovery := 0.05
var gravity_scale := 0.5

func enter(msg := {}) -> void:
	if msg.get(0) != null:
		player.velocity = msg.get(0)

func physics_update(delta: float) -> void:
	player.velocity.x = lerp(player.velocity.x, 0, knockback_recovery)
	player.velocity.y += player.GRAVITY * delta * gravity_scale
	player.velocity = player.move_and_slide(player.velocity)
	if player.velocity.x < 100 && player.velocity.x > -100:
		if player.is_on_floor():
			state_machine.transition_to("Run")
		else: state_machine.transition_to("Air")
