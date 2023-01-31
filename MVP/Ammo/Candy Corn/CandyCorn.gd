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
extends Area2D

export var SPEED = 400

export var enemy_knockback = 0
export var player_knockback = 0

var direction = Vector2.ZERO

func _physics_process(delta):
	position += delta * SPEED * direction

func _on_Hit(body):
	if body.get_collision_layer_bit(0):
		queue_free()
	elif body.get_collision_layer_bit(1):
		body.take_damage(GlobalVars.get_ammo("Candy Corn").damage, direction.normalized() * enemy_knockback)
		queue_free()

func launch(bullet_direction : Vector2, _strength) -> void:
	direction = bullet_direction
	rotation = direction.angle()
	if direction.angle() > PI/2:
		$Sprite.flip_v = true
