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
class_name Heart
extends KinematicBody2D

const WAVE_DAMAGE = 20
const BODY_DAMAGE = 10
const GRAB_DAMAGE = 20
const WAVE_STRENGTH = 100

var health = 20
var target
var facing_left := true
var motion := Vector2.ZERO

onready var animation_player := $AnimationPlayer
onready var state_machine := $StateMachine
onready var body_hit_collision := $Body/CollisionShape2D
onready var shield_zone := $ShieldZone

func knockback(vector:Vector2):
	motion += vector

func take_damage(damage:int, _vector:Vector2):
	if state_machine.state == $StateMachine/Blocking:
		return
	elif state_machine.state == $StateMachine/Asleep:
		$StateMachine/Asleep._on_PlayerDetector_body_entered(get_tree().current_scene.player)
	health -= damage
	if health <= 0:
		state_machine.transition_to("Death")
	else:
		$Sprite.get_material().set("shader_param/flashState", 1.0)
		yield(get_tree().create_timer(0.1), "timeout")
		$Sprite.get_material().set("shader_param/flashState", 0.0)

func _physics_process(delta):
	if health > 0:
		motion.y += 10
		motion.x = lerp(motion.x, 0, 0.1)
		motion = move_and_slide(motion)

func on_ran_into_something(something):
	if something is Player:
		something.take_damage(BODY_DAMAGE, Vector2(WAVE_STRENGTH * (-1 if facing_left else 1), -50))
