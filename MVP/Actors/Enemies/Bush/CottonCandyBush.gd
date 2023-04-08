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
class_name CandyBush
extends KinematicBody2D

const WAVE_DAMAGE = 10
const BODY_DAMAGE = 10
const GRAB_DAMAGE = 20
const PULL_STRENGTH = 400
const WAVE_STRENGTH = 100

var health = 20
var target
var facing_left := true

onready var animation_player := $AnimationPlayer
onready var state_machine := $StateMachine
onready var grab_position := $GrabPosition
onready var body_hit_collision := $BodyHitZone/CollisionShape2D
onready var detection_zone := $PlayerDetector

# It's a bush it won't move
func knockback(_vector:Vector2):
	pass

func take_damage(damage:int, _vector:Vector2):
	health -= damage
	if state_machine.state == $StateMachine/Asleep:
		$StateMachine/Asleep.on_thing_seen(get_tree().current_scene.player)
	if health <= 0:
		state_machine.transition_to("Death")
	else:
		$Sprite.get_material().set("shader_param/flashState", 1.0)
		yield(get_tree().create_timer(0.1), "timeout")
		$Sprite.get_material().set("shader_param/flashState", 0.0)


func on_ran_into_something(something):
	if something is Player:
		something.take_damage(BODY_DAMAGE, Vector2(WAVE_STRENGTH * (-1 if facing_left else 1), -50))
