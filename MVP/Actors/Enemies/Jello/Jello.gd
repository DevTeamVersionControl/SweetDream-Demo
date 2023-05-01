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

export var health = 3
export(float, 0.5, 2.5) var initial_volume = 2.1
export var inverse_drop_chance = 1

onready var animation_player = $AnimationPlayer
onready var state_machine = $StateMachine
onready var sprite = $Sprite

# Sound effects
onready var audio_stream_player := $AudioStreamPlayer
const HIT = preload("res://Actors/Enemies/Enemy Hit.wav")
const JELLO_DEATH = preload("res://Actors/Enemies/Jello/Jello Death.wav")
const JELLO_JUMP = preload("res://Actors/Enemies/Jello/Jello Jump.wav")

func _ready():
	grow(initial_volume)
	health *= volume

func take_damage(damage, knockback):
	health -= damage
	motion += knockback
	if state_machine.state.name == "Idle":
		$StateMachine/Idle.on_something_detected(get_tree().current_scene.player)
	if health <= 0 && animation_player.current_animation != "Death":
		state_machine.transition_to("Death")
		audio_stream_player.stream = JELLO_DEATH
	else:
		$Sprite.get_material().set("shader_param/flashState", 1.0)
		yield(get_tree().create_timer(0.1), "timeout")
		$Sprite.get_material().set("shader_param/flashState", 0.0)
		audio_stream_player.stream = HIT
	audio_stream_player.play()

func on_hit_something(something):
	if something is Player && health > 0:
		something.take_damage(DAMAGE, motion)

func grow(add_volume:float)->void:
	volume += add_volume
	set_deferred("scale", Vector2(volume,volume))
