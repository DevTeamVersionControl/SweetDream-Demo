extends PlayerState

#Handles knockback

var big_knockback := false
var knockback_recovery := 0.1
var gravity_scale := 0.5

func enter(msg := {}) -> void:
	if msg.get(0) != null:
		big_knockback = false if msg.get(0).length() < 5000 else true
		player.velocity = msg.get(0, Vector2.ZERO) as Vector2

func physics_update(delta: float) -> void:
	player.velocity.x = lerp(player.velocity.x, 0, knockback_recovery)
	player.velocity.y += player.GRAVITY * delta * gravity_scale
	player.velocity = player.move_and_slide(player.velocity)
	if player.velocity.x < 100:
		if player.is_on_floor():
			state_machine.transition_to("Run")
		else: state_machine.transition_to("Air")
