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

signal died

enum PHASE {FIRST, SECOND, THIRD}

const CHARGE_DAMAGE = 30
const BASE_DAMAGE = 10

var motion := Vector2.ZERO
var facing_right := true
var health := 70
var gravity := 10
var phase = PHASE.FIRST
var should_transition := false

onready var animation_player := $AnimationPlayer
onready var state_machine := $StateMachine
onready var sprite := $Sprite
onready var wall_sensor := $BodyCollisionZone
onready var collision := $CollisionShape2D
onready var body_hitbox := $BodyCollisionZone/Hitbox

# Sound effects
onready var audio_stream_player := $AudioStreamPlayer
const DEATH = preload("res://Actors/Enemies/Bosses/Jaw Breaker/Jawbreaker Boss Death.wav")
const DASH = preload("res://Actors/Enemies/Bosses/Jaw Breaker/Jawbreaker Boss Dash.wav")
const SHOOT = preload("res://Actors/Enemies/Bosses/Jaw Breaker/Jawbreaker Boss Shoot.wav")
const GROUND_SLAM = preload("res://Actors/Enemies/Bosses/Jaw Breaker/Jawbreaker Boss Slam.wav")
const WIND_UP = preload("res://Actors/Enemies/Bosses/Jaw Breaker/Jawbreaker Boss Wind Up.wav")

func take_damage(damage, knockback):
	if phase == PHASE.SECOND:
		health -= damage
		motion += knockback
		if health <= 0:
			# Makes it so the boss doesn't teleport when going to phase 3
			should_transition = true
		else:
			sprite.get_material().set("shader_param/flashState", 1.0)
			yield(get_tree().create_timer(0.1), "timeout")
		sprite.get_material().set("shader_param/flashState", 0.0)
		$AudioStreamPlayer2D.play()

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
	if phase == PHASE.FIRST:
		animation_player.play("Down")
		yield(animation_player,"animation_finished")
		phase = PHASE.SECOND
		state_machine.transition_to("Idle", {initial_charge = true})
	elif phase == PHASE.THIRD:
		state_machine.state.activate()

func play_ground_slam():
	audio_stream_player.volume_db = 10
	audio_stream_player.stream = GROUND_SLAM
	audio_stream_player.play()
	yield(audio_stream_player,"finished")
