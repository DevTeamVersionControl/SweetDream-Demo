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

const DAMAGE = 20
const PULL_STRENGTH = 400

var hp = 20
var target
var facing_left := true

onready var animation_player := $AnimationPlayer
onready var state_machine := $StateMachine

# It's a bush it won't move
func knockback(_vector:Vector2):
	pass

func take_damage(damage:int, _vector:Vector2):
	hp -= damage
	if hp <= 0:
		state_machine.transition_to("Death")
