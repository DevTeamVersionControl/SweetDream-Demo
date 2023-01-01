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
class_name Jawbreaker
extends KinematicBody2D

const BASE_DAMAGE = 5
const CHARGE_DAMAGE = 20

var target
var facing_right := true

export var motion = Vector2()
export var hp = 20
export var gravity = 200

onready var animation_player := $AnimationPlayer
onready var state_machine := $StateMachine
onready var player_detector_collision := $PlayerDetector/CollisionShape2D

func take_damage(damage, knockback):
	hp -= damage
	motion += knockback
	if hp <= 0:
		state_machine.transition_to("Death")
#	else:
#		$AnimatedSprite.animation = "Hit"
#		yield($AnimatedSprite, "animation_finished")

func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("player"):
		target = body
		state_machine.state.activate()
		player_detector_collision.set_deferred("disabled", true)


func on_hit_something(something):
	if something is Player:
		if state_machine.state == $StateMachine/Charge:
			something.take_damage(CHARGE_DAMAGE, motion)
		else:
			something.take_damage(BASE_DAMAGE, Vector2.ZERO)
