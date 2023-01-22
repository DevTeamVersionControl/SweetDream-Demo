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
class_name JellyBean

extends KinematicBody2D

export var THROW_velocity = 200
export var THROW_ANGLE = 30
export var GRAVITY = 500
export var enemy_knockback = 10
export var player_knockback = 5
export var player_explosion_knockback = 10

onready var jelly_bean_sprite = $JellyBeanSprite
onready var explosion_sprite = $ExplosionSprite
onready var animation_player = $AnimationPlayer
onready var explosion_collision = $ExplosionCollision
onready var explosion_timer = $ExplosionTimer

var velocity = Vector2.ZERO

func launch(direction, _strength):
#	if direction.x == 1:
#		velocity = Vector2(cos(deg2rad(THROW_ANGLE)),sin(deg2rad(THROW_ANGLE))) * THROW_velocity
#	elif direction.x == -1:
#		velocity = Vector2(cos(deg2rad(180 - THROW_ANGLE)),sin(deg2rad(180 - THROW_ANGLE))) * THROW_velocity
	velocity = direction * THROW_velocity
	#get_parent().motion += -velocity.normalized() * player_knockback
	
func shake():
	get_tree().current_scene.shaker.start(0.2, 20, 2)
