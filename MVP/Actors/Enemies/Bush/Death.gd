extends BushState

func enter(_msg := {}) -> void:
	if bush.facing_left:
		bush.animation_player.play("DeathLeft")
	else:
		bush.animation_player.play("DeathRight")
