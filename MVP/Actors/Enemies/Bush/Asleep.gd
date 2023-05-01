extends BushState

func enter(msg := {}) -> void:
	if (msg.has(0)):
		if (bush.facing_left):
			bush.animation_player.play("WakeUpLeft", -1.0, 1.0, true)
		else:
			bush.animation_player.play("WakeUpRight", -1.0, 1.0, true)
	else:
		bush.animation_player.play("WakeUpLeft")
	bush.animation_player.stop(false)
	if (msg.has(0)):
		bush.animation_player.seek(bush.animation_player.current_animation_length, true)
	else:
		bush.animation_player.seek(0, true)
	
func physics_update(delta: float) -> void:
	if bush.target != null:
		bush.animation_player.advance(delta)
	else:
		if is_equal_approx(bush.animation_player.get_current_animation_position(), 0):
			bush.body_hit_collision.disabled = true
		else:
			bush.animation_player.seek(bush.animation_player.get_current_animation_position() - delta, true)

func wake_up() -> void:
	bush.body_hit_collision.disabled = false
	state_machine.transition_to("Idle")

func on_thing_seen(thing):
	if thing is Player:
		bush.target = thing
		bush.audio_stream_player.stream = bush.AWAKENING
		bush.audio_stream_player.play()
