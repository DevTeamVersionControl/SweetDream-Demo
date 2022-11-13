extends StickyBombState

func enter(_msg := {}) -> void:
	sticky_bomb.explosion_timer.start()
	sticky_bomb.animation_player.play("Flying")

func physics_update(delta: float) -> void:
	sticky_bomb.velocity.y += sticky_bomb.GRAVITY * delta
	var collision = sticky_bomb.move_and_collide(sticky_bomb.velocity*delta, false)
	if collision != null:
		state_machine.transition_to("Stuck")
