extends BushState

func enter(_msg := {}) -> void:
	if bush.facing_left:
		bush.animation_player.play_backwards("AttackLeft")
	else:
		bush.animation_player.play_backwards("AttackRight")

func hit_something(something):
	if something is Player:
		something.take_damage(bush.DAMAGE, Vector2(bush.PULL_STRENGTH * 1 if bush.facing_left else -1, -50))
