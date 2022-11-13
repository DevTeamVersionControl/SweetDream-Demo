extends JellyBeanState

# Affects how much being near the center of the explosion affects the knockback
var explosion_location_weight := 5
var explosion_strength := 6000

func enter(_msg := {}) -> void:
	jelly_bean.explosion_collision.monitorable = true
	jelly_bean.explosion_collision.monitoring = true
	jelly_bean.animation_player.play("Exploding")

func _on_Explosion(body):
	if body.is_in_group("enemy"):
		body.knockback(calculate_explosion_knockback(body.global_position))
		body.take_damage(jelly_bean.DAMAGE)
	elif body.is_in_group("player"):
		body.knockback(calculate_explosion_knockback(body.global_position))

func calculate_explosion_knockback(body_pos:Vector2) -> Vector2:
	# Direction
	var explosion_knockback := (body_pos - jelly_bean.global_position).normalized()
	# Strength based on closeness to explosion
	explosion_knockback *= explosion_location_weight/(explosion_location_weight * (body_pos - jelly_bean.global_position).length())
	return explosion_knockback * explosion_strength
