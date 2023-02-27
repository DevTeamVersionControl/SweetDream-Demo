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

const BREAK_VOLUME = 2.0
const NUM_OF_BABIES = 3
const JUMP_VELOCITY_Y = 300
const JUMP_VELOCITY_X = 80
const GRAVITY = 10
const DAMAGE = 10

var motion = Vector2()
var target
var facing_right := true
var is_on_floor:bool
var volume := 0.5
#var stuck := false

export var health = 10
export(float, 0.5, 2.5) var initial_volume = 2.1

onready var animation_player = $AnimationPlayer
onready var state_machine = $StateMachine
onready var sprite = $Sprite

func _ready():
	grow(initial_volume)

func take_damage(damage, knockback):
	health -= damage
	motion += knockback
	if health <= 0 && animation_player.current_animation != "Death":
		state_machine.transition_to("Death")
	else:
		$Sprite.get_material().set("shader_param/flashState", 1.0)
		yield(get_tree().create_timer(0.1), "timeout")
		$Sprite.get_material().set("shader_param/flashState", 0.0)

func on_hit_something(something):
	if something is Player && health > 0:
		something.take_damage(DAMAGE, motion)

func grow(add_volume:float)->void:
	volume += add_volume
	set_deferred("scale", Vector2(volume,volume))
