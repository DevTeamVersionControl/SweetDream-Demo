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
class_name Player
extends KinematicBody2D

signal changed_ammo()
signal changed_health()
signal changed_health_pack()

const SPEED = 120
const GRAVITY = 1200
const JUMP_IMPULSE = 300
const JUMP_ACCEL = 600
const DECELERATION = 0.1
const ACCELERATION = 10
const HEAL_FROM_CANDY = 20

var velocity = Vector2.ZERO
var level_limit_min
var level_limit_max
var facing_right := true
var can_shoot := true
var invulnerable := false

# References to nodes in case they are changed
onready var cooldown_timer := $CooldownTimer
onready var animation_tree := $AnimationTree
onready var animation_mode = animation_tree.get("parameters/playback")
onready var bullet_center := $BulletCenter
onready var state_machine := $StateMachine
onready var camera_arm = $"Camera arm"
onready var camera = $"Camera arm/Camera2D"
onready var animation_player = $AnimationPlayer
onready var shoot_bar = $ShootBar
onready var cooldown_bar = $CooldownBar
onready var invulnerability_timer = $InvulnerabilityTimer

func _ready():
	set_later(camera, "smoothing_enabled", true)
	call_deferred("emit_signal", "changed_health")
	call_deferred("emit_signal", "changed_health_pack")
	camera_arm.position.x = 127 if facing_right else -127
	camera.limit_left = level_limit_min.x
	camera.limit_top = level_limit_min.y
	camera.limit_right = level_limit_max.x
	camera.limit_bottom = level_limit_max.y

func _physics_process(_delta):
	if Input.is_action_just_pressed("ammo_next"):
		GlobalVars.equiped_ammo_index = (GlobalVars.equiped_ammo_index + 1) % GlobalVars.ammo_equipped_array.size()
		emit_signal("changed_ammo")
	if Input.is_action_just_pressed("consume_health_pack"):
		if GlobalVars.health_packs > 0:
			set_health_packs(GlobalVars.health_packs - 1)
			heal(HEAL_FROM_CANDY)
	if !can_shoot:
		cooldown_bar.scale.x = cooldown_timer.time_left/cooldown_timer.wait_time/100

func knockback(knockback_vector: Vector2):
	#Adjust the explosion vector to account for the player global position being at the bottom
	state_machine.transition_to("Knockback", {0:Vector2(knockback_vector.x, -0.2 * knockback_vector.y)})

func calculate_bullet_direction() -> Vector2:
	var raw_bullet_direction = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up"))
	if raw_bullet_direction.y > 0 && raw_bullet_direction.x != 0:
		raw_bullet_direction.x = 0
	if raw_bullet_direction.length() == 0:
		raw_bullet_direction.x = 1 if facing_right else -1
	return raw_bullet_direction.normalized()

func take_damage(damage:float, knockback:Vector2) -> void:
	if !invulnerable:
		invulnerable = true
		invulnerability_timer.start()
		knockback(knockback)
		GlobalVars.health -= damage
		emit_signal("changed_health")
		if GlobalVars.health <= 0:
			GlobalVars.health = 0
			if GlobalVars.health_packs > 0:
				heal(1)
				set_health_packs(0)
			else:
				get_tree().current_scene.die()
			emit_signal("changed_health")

func heal(damage_healed:float):
	GlobalVars.health += damage_healed
	if GlobalVars.health > GlobalVars.max_health:
		GlobalVars.health = GlobalVars.max_health
	emit_signal("changed_health")
	
func knock_out(time:float):
	state_machine.transition_to("KnockedOut", {0:time})

func wake_up():
	state_machine.transition_to("Idle")

func set_later(object:Node, variable:String, val):
	yield(get_tree().create_timer(0.01), "timeout")
	object.set_deferred(variable, val)

func set_health_packs(packs:int):
	GlobalVars.health_packs = packs
	emit_signal("changed_health_pack")

func on_invulnerability_off():
	invulnerable = false
