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
		body.take_damage(GlobalVars.get_ammo("Jelly Bean").damage, calculate_explosion_knockback(body.global_position))
	elif body.is_in_group("player"):
		body.knockback(calculate_explosion_knockback(body.global_position))

func calculate_explosion_knockback(body_pos:Vector2) -> Vector2:
	# Direction
	var explosion_knockback := (body_pos - jelly_bean.global_position).normalized()
	# Strength based on closeness to explosion
	explosion_knockback *= explosion_location_weight/(explosion_location_weight * (body_pos - jelly_bean.global_position).length())
	return explosion_knockback * explosion_strength
