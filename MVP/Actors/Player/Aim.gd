extends PlayerState

# Workaround because "animation_finished" signal is not emitted when it finishes so I have to estimate the time the animation will take
# Will probably need to change when the real animation comes and forget about it and have a really annoying bug to find
const SHOOT_ANIMATION_TIME = 0.1
const CHARGE = 1

var bullet_strength : float
var bullet_direction : Vector2

var held_ammo

func enter(_msg := {}) -> void:
	player.shoot_bar.visible = true
	player.shoot_bar.scale.x = 0
	bullet_strength = 0
	player.velocity.x = 0
	bullet_direction = player.calculate_bullet_direction()
	player.animation_tree.set("parameters/conditions/not_held", false if held_ammo else true)
	player.animation_tree.set('parameters/Aim/blend_position', bullet_direction + Vector2(0.1 if player.facing_right else -0.1, 0))
	player.animation_tree.set('parameters/Shoot/blend_position', bullet_direction + Vector2(0.1 if player.facing_right else -0.1, 0))
	player.animation_mode.travel("Aim")
	
	match(GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index].type):
		GlobalTypes.AMMO_TYPE.once:
			shoot_animation()
		GlobalTypes.AMMO_TYPE.constant:
			pass
		GlobalTypes.AMMO_TYPE.charge:
			pass

func physics_update(delta: float) -> void:
	player.velocity.y += player.GRAVITY * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	if GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index].type == GlobalTypes.AMMO_TYPE.charge && Input.is_action_pressed("shoot"):
		bullet_strength += delta
		if bullet_strength >= CHARGE:
			bullet_strength = CHARGE
	player.shoot_bar.scale.x = bullet_strength/100
	if Input.is_action_just_released("shoot"):
		if bullet_strength > 0.5:
			shoot_animation()
		else:
			player.shoot_bar.visible = false
			state_machine.transition_to("Idle")

func shoot_animation():
	player.animation_mode.travel("Shoot")
	player.shoot_bar.visible = false
	yield(get_tree().create_timer(SHOOT_ANIMATION_TIME), "timeout")
	player.cooldown_bar.visible = true
	state_machine.transition_to("Idle")

# Shoots individual bullets
func shoot(position:NodePath) -> void:
	if !player.can_shoot:
		return
	player.can_shoot = false
	var bullet = GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index].scene.instance()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = player.get_node(position).global_position
	
	player.cooldown_timer.start(GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index].cooldown)
	
	state_machine.transition_to("Knockback", {0: bullet.launch((player.get_node(position).global_position - player.bullet_center.global_position).normalized(), bullet_strength)})

func _on_CooldownTimer_timeout() -> void:
	player.can_shoot = true
	player.cooldown_bar.visible = false
