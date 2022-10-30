class_name Player
extends KinematicBody2D

signal changed_ammo(ammo_index)

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

# References to nodes in case they are changed
onready var cooldown_timer := $CooldownTimer
onready var animation_tree := $AnimationTree
onready var animation_mode = animation_tree.get("parameters/playback")
onready var bullet_center := $BulletCenter
onready var state_machine := $StateMachine
onready var camera = $"Camera arm/Camera2D"

func _physics_process(_delta):
	
	if Input.is_action_just_pressed("ammo_next"):
		if held_ammo != null:
			held_ammo.queue_free()
			held_ammo = null
		GlobalVars.equiped_ammo = GlobalVars.ammo_instance_array.find(GlobalVars.ammo_equipped_array[(GlobalVars.ammo_equipped_array.find(GlobalVars.ammo_instance_array[GlobalVars.equiped_ammo], 0) + 1) % GlobalVars.ammo_equipped_array.size()], 0)
		emit_signal("changed_ammo", GlobalVars.equiped_ammo)

# Shoots individual bullets
func shoot(position:NodePath) -> void:
	if !can_shoot:
		return
	can_shoot = false
	var bullet = GlobalVars.ammo_instance_array[GlobalVars.equiped_ammo].instance()
	get_tree().current_scene.add_child(bullet)
	
	bullet.set_direction((get_node(position).global_position - bullet_center.global_position).normalized())
	
	bullet.global_position = get_node(position).global_position
	
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

func knockback(knockback_vector: Vector2):
	#Adjust the explosion vector to account for the player global position being at the bottom
	var strength = knockback_vector.length()
	state_machine.transition_to("Knockback", {0:((knockback_vector.normalized() + Vector2.UP/2).normalized()) * strength})
