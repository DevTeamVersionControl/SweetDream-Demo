extends BushState

func enter(_msg := {}) -> void:
	if (bush.facing_left):
		bush.animation_player.play("IdleLeft")
	else:
		bush.animation_player.play("IdleRight")

func attack():
	if bush.target != null:
		bush.facing_left = true if bush.target.global_position.x - bush.global_position.x < 0 else false
		state_machine.transition_to("Attacking")
	else:
		state_machine.transition_to("Asleep", {0:"From attack"})
