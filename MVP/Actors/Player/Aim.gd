# Sweet Dream, a sweet metroidvannia
#    Copyright (C) 2022 Kamran Charles Nayebi and William Duplain
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
extends PlayerState

# Workaround because "animation_finished" signal is not emitted when it finishes so I have to estimate the time the animation will take
# Will probably need to change when the real animation comes and forget about it and have a really annoying bug to find
const SHOOT_ANIMATION_TIME = 0.1
const CHARGE = 1

var bullet_strength : float
var bullet_direction : Vector2
var crouched : bool

var held_ammo

func enter(msg := {}) -> void:
	player.shoot_bar.visible = true
	player.shoot_bar.scale.x = 0
	bullet_strength = 0
	player.velocity.x = 0
	bullet_direction = player.calculate_bullet_direction()
	
	if msg.has("crouched"):
		player.animation_tree.set('parameters/AimCrouched/blend_position', 1 if player.facing_right else -1)
		player.animation_tree.set('parameters/ShootCrouched/blend_position', 1 if player.facing_right else -1)
		player.animation_mode.travel("AimCrouched")
		crouched = true
	else:
		player.animation_mode.travel("Aim")
		player.animation_tree.set('parameters/Aim/blend_position', bullet_direction + Vector2(0.1 if player.facing_right else -0.1, 0))
		crouched = false
	player.animation_tree.set('parameters/Shoot/blend_position', bullet_direction + Vector2(0.1 if player.facing_right else -0.1, 0))
	
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
			state_machine.transition_to("Idle" if !crouched else "Crouched")

func shoot_animation():
	player.animation_mode.travel("Shoot" if !crouched else "ShootCrouched")
	player.shoot_bar.visible = false
	yield(get_tree().create_timer(SHOOT_ANIMATION_TIME), "timeout")
	player.cooldown_bar.visible = true
	state_machine.transition_to("Idle" if !crouched else "Crouched")

# Shoots individual bullets
func shoot(position:NodePath) -> void:
	if !player.can_shoot:
		return
	player.can_shoot = false
	var bullet = GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index].scene.instance()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = player.get_node(position).global_position
	
	player.cooldown_timer.start(GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index].cooldown)
	
	var knockback = bullet.launch((player.get_node(position).global_position - player.bullet_center.global_position).normalized(), bullet_strength)
	
	GlobalVars.sugar -= GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index].sugar
	player.update_display()
	player.sugar_timer.start()
	
	if !crouched:
		state_machine.transition_to("Knockback", {0: knockback})

func _on_CooldownTimer_timeout() -> void:
	player.can_shoot = true
	player.cooldown_bar.visible = false
