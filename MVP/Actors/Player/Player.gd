class_name Player
extends KinematicBody2D

signal changed_ammo(ammo_index)

const SPEED = 120
const GRAVITY = 1200
const JUMP_IMPULSE = 400
const JUMP_ACCEL = 600

var velocity = Vector2.ZERO
var level_limit = Vector2(1920, 1080)
var facing_right := true
var can_shoot := true

# References to nodes in case they are changed
onready var cooldown_timer := $CooldownTimer
onready var animation_tree := $AnimationTree
onready var animation_mode = animation_tree.get("parameters/playback")
onready var bullet_center := $BulletCenter
onready var state_machine := $StateMachine
onready var camera_arm = $"Camera arm/Camera2D"
onready var animation_player = $AnimationPlayer
onready var shoot_bar = $ShootBar
onready var cooldown_bar = $CooldownBar

func _physics_process(_delta):
	if Input.is_action_just_pressed("ammo_next"):
		GlobalVars.equiped_ammo_index = (GlobalVars.equiped_ammo_index + 1) % GlobalVars.ammo_equipped_array.size()
		emit_signal("changed_ammo", GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index])
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
