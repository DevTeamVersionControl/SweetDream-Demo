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
class_name JelloEnemy
extends KinematicBody2D

const MIN_VOLUME = 0.5
const MAX_VOLUME = 2.86
const NUM_OF_BABIES = 3
const JUMP_VELOCITY_Y = 150
const JUMP_VELOCITY_X = 40
const GRAVITY = 5
const DAMAGE = 10

var motion = Vector2()
var target
var facing_right := true
var is_on_floor:bool
var volume := MIN_VOLUME

export var hp = 10

onready var animation_player = $AnimationPlayer
onready var state_machine = $StateMachine

func take_damage(damage, knockback):
	hp -= damage
	motion += knockback
	if hp <= 0:
		state_machine.transition_to("Death")

func on_hit_something(something):
	if something is Player:
		something.take_damage(DAMAGE, motion)
