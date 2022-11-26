extends PlayerState

# Workaround because "animation_finished" signal is not emitted when it finishes so I have to estimate the time the animation will take
# Will probably need to change when the real animation comes and forget about it and have a really annoying bug to find
const SHOOT_ANIMATION_TIME = 0.1

func enter(_msg := {}) -> void:
	player.velocity.x = 0
	player.bullet_direction = player.calculate_bullet_direction()
	player.animation_tree.set("parameters/conditions/not_held", false if player.held_ammo else true)
	player.animation_tree.set('parameters/Aim/blend_position', player.bullet_direction + Vector2(0.1 if player.facing_right else -0.1, 0))
	player.animation_tree.set('parameters/Shoot/blend_position', player.bullet_direction + Vector2(0.1 if player.facing_right else -0.1, 0))
	player.animation_mode.travel("Aim")
	
	match(GlobalVars.equiped_ammo.type):
		GlobalTypes.AMMO_TYPE.once:
			player.animation_mode.travel("Shoot")
			yield(get_tree().create_timer(SHOOT_ANIMATION_TIME), "timeout")
			state_machine.transition_to("Idle")
		GlobalTypes.AMMO_TYPE.constant:
			pass
		GlobalTypes.AMMO_TYPE.charge:
			pass

func physics_update(delta: float) -> void:
	player.velocity.y += player.GRAVITY * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
