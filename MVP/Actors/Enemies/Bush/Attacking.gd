extends BushState

func enter(_msg := {}) -> void:
	if bush.facing_left:
		bush.animation_player.play("AttackLeft", -1, -1, true)
	else:
		bush.animation_player.play("AttackRight", -1, -1, true)

func hit_something(something):
	if something is Player:
		something.take_damage(bush.DAMAGE, Vector2(bush.PULL_STRENGTH * (1 if bush.facing_left else -1), -100))
