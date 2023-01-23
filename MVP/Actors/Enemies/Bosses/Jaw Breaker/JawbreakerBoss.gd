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
class_name JawbreakerBoss
extends KinematicBody2D

enum PHASE {FIRST, SECOND, THIRD}

const CHARGE_DAMAGE = 30
const BASE_DAMAGE = 10

var motion := Vector2.ZERO
var facing_right := true
var health := 10
var gravity := 10
var phase = PHASE.FIRST

onready var animation_player := $AnimationPlayer
onready var state_machine := $StateMachine
onready var sprite := $Sprite
onready var wall_sensor := $BodyCollisionZone

func take_damage(damage, knockback):
	health -= damage
	motion += knockback
	if health <= 0:
		state_machine.transition_to("Death")
	else:
		$Sprite.get_material().set("shader_param/flashState", 1.0)
		yield(get_tree().create_timer(0.1), "timeout")
		$Sprite.get_material().set("shader_param/flashState", 0.0)

func on_hit_something(something):
	if something is Player && health > 0:
		if motion.x > 100 || motion.x < -100:
			something.take_damage(CHARGE_DAMAGE, motion)
		else:
			something.take_damage(BASE_DAMAGE, Vector2.ZERO)
	if something.is_in_group("destructable"):
		something.disappear()

#Starts the second phase
func _on_EnemyCounter_on():
	animation_player.play("Down")
	yield(animation_player,"animation_finished")
	phase = PHASE.SECOND
	state_machine.transition_to("Idle")
