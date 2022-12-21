extends BushState

func enter(_msg := {}) -> void:
	bush.animation_player.play("WakeUpLeft")
	bush.animation_player.stop(true)
	
func physics_update(delta: float) -> void:
	if bush.target != null:
		bush.animation_player.advance(delta)
	else:
		bush.animation_player.seek(bush.animation_player.get_current_animation_position() - delta, true)

func wake_up() -> void:
	state_machine.transition_to("Idle")

func on_thing_seen(thing):
	if thing is Player:
		bush.target = thing

func on_thing_exited(thing):
	if thing is Player:
		bush.target = null
