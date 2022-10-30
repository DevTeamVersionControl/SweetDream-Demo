extends StickyBombState

func enter(_msg := {}) -> void:
	sticky_bomb.explosion_timer.start()
	sticky_bomb.animation_player.play("Stuck")

func _on_ExplosionTimer_timeout():
	state_machine.transition_to("Exploding")
