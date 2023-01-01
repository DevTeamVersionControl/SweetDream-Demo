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
extends KinematicBody2D

export var THROW_VELOCITY = 50
export var THROW_ANGLE = 0
export var COOLDOWN = 1
const PIXELS_PER_METER = 16
export var gravity = 9.8
var touched_something:= false

export var enemy_knockback = 100
export var player_knockback = 300

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += gravity/2 * pow(delta * 20, 2)
	var collision = move_and_collide(velocity*delta*PIXELS_PER_METER)
	if velocity.length() > 5 || velocity.length() < -5:
			if velocity.x > 0:
				rotation = velocity.angle()
			else: 
				rotation = PI + velocity.angle()
	if collision != null:
		if !touched_something:
			$Timer.start()
			touched_something = true
		_on_impact(collision.normal)
		
func launch(direction, strength)->Vector2:
	velocity = direction * strength * THROW_VELOCITY
	return -velocity.normalized() * player_knockback

func _on_impact(normal):
	velocity = velocity.bounce(normal)
	velocity *= 0.8

func _on_Area2D_body_entered(body):
	if body.is_in_group("destructable"):
		body.disappear()
		queue_free()
	if body.is_in_group("enemy"):
		body.take_damage(GlobalVars.get_ammo("Jawbreaker").damage, velocity.normalized() * enemy_knockback)

func _on_Timer_timeout():
	queue_free()
