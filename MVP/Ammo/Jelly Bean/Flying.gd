extends JellyBeanState

var bounces := 0
export var sticky := false

func enter(_msg := {}) -> void:
	jelly_bean.explosion_timer.start()
	jelly_bean.animation_player.play("Flying")

func physics_update(delta: float) -> void:
	jelly_bean.velocity.y += jelly_bean.GRAVITY * delta
	var collision = jelly_bean.move_and_collide(jelly_bean.velocity*delta, false)
	if collision != null && !sticky:
		_on_inpact(collision.normal)

func _on_inpact(normal):
	bounces += 1
	if bounces < 2:
		jelly_bean.velocity = jelly_bean.velocity.bounce(normal)
		jelly_bean.velocity *= 0.5
	else:
		jelly_bean.velocity = Vector2.ZERO

func _on_ExplosionTimer_timeout():
	state_machine.transition_to("Exploding")
