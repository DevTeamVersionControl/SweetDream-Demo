class_name Player
extends KinematicBody2D

const SPEED = 120
const GRAVITY = 1200
const JUMP_IMPULSE = 400
const JUMP_ACCEL = 600

var velocity = Vector2.ZERO
var level_limit = Vector2(1920, 1080)
var can_shoot := true
var held_ammo
var facing_right := true
var bullet_direction : Vector2

# Animation node variables
var shooting := false
var run := true
var idle := false
var air := false

# References to nodes in case they are changed
onready var cooldown_timer := $CooldownTimer
onready var animation_tree := $AnimationTree
onready var animation_mode = animation_tree.get("parameters/playback")

func _physics_process(_delta):
	# Easy way to stop debugging for now, will be changed when there is a menu
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()


# Shoots individual bullets
func shoot(position:NodePath) -> void:
	var bullet = GlobalVars.ammo_instance_array[GlobalVars.equiped_ammo].instance()
	get_tree().current_scene.add_child(bullet)
	
	bullet.set_direction(calculate_bullet_direction())
	
	bullet.global_position = get_node(position).global_position
	
	can_shoot = false
	shooting = false
	cooldown_timer.start(bullet.COOLDOWN)

func calculate_bullet_direction() -> Vector2:
	var raw_bullet_direction = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up"))
	if raw_bullet_direction.y > 0 && raw_bullet_direction.x != 0:
		raw_bullet_direction.x = 0
	if raw_bullet_direction.length() == 0:
		raw_bullet_direction.x = 1 if facing_right else -1
	return raw_bullet_direction.normalized()

func _on_CooldownTimer_timeout() -> void:
	can_shoot = true
