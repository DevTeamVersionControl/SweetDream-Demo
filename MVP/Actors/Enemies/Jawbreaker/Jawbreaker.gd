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

signal died

const BASE_DAMAGE = 5
const CHARGE_DAMAGE = 20

var target

export var initial_target_player : bool
export var facing_right := true
export var motion = Vector2()
export var health = 20
export var gravity = 100

onready var animation_player := $AnimationPlayer
onready var state_machine := $StateMachine
onready var player_detector_collision := $PlayerDetector/CollisionShape2D
onready var sprite := $Sprite

func _ready():
	# If the jawbreaker has an initial target, attack it immediately
	if initial_target_player:
		target = null
		if get_tree().current_scene.player == null:
			yield(get_tree().current_scene, "ready")
		_on_PlayerDetector_body_entered(get_tree().current_scene.player)

func take_damage(damage, knockback):
	health -= damage
	motion += knockback
	if health <= 0:
		emit_signal("died")
		state_machine.transition_to("Death")
	else:
		$Sprite.get_material().set("shader_param/flashState", 1.0)
		yield(get_tree().create_timer(0.1), "timeout")
		$Sprite.get_material().set("shader_param/flashState", 0.0)

func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("player") && state_machine.state.name == "Idle":
		target = body
		state_machine.state.activate()
		player_detector_collision.set_deferred("disabled", true)

func on_hit_something(something):
	if something is Player && health > 0:
		if motion.x > 100 || motion.x < -100:
			something.take_damage(CHARGE_DAMAGE, motion)
		else:
			something.take_damage(BASE_DAMAGE, Vector2.ZERO)

func _on_WallDetector_body_entered(body):
	if body.is_in_group("floor"):
		if state_machine.state.name == "Charge" || state_machine.state.name == "WindUp" || state_machine.state.name == "WindDown":
			state_machine.state.stun()
