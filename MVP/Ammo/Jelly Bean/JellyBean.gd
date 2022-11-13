class_name JellyBean

extends KinematicBody2D

export var THROW_velocity = 200
export var THROW_ANGLE = 30
export var GRAVITY = 500
const COOLDOWN = 1
const DAMAGE = 5
export var enemy_knockback = 10
export var player_knockback = 5
export var player_explosion_knockback = 10

onready var jelly_bean_sprite = $JellyBeanSprite
onready var explosion_sprite = $ExplosionSprite
onready var animation_player = $AnimationPlayer
onready var explosion_collision = $ExplosionCollision
onready var explosion_timer = $ExplosionTimer

var velocity = Vector2.ZERO

func set_direction(direction):
#	if direction.x == 1:
#		velocity = Vector2(cos(deg2rad(THROW_ANGLE)),sin(deg2rad(THROW_ANGLE))) * THROW_velocity
#	elif direction.x == -1:
#		velocity = Vector2(cos(deg2rad(180 - THROW_ANGLE)),sin(deg2rad(180 - THROW_ANGLE))) * THROW_velocity
	velocity = direction * THROW_velocity
	#get_parent().motion += -velocity.normalized() * player_knockback

func _on_Area2D_body_entered(body):
	if body.is_in_group("destructable"):
		body.disappear()
	if body.is_in_group("enemy"):
		body.take_damage(DAMAGE, (body.global_position - global_position).normalized() * enemy_knockback)
	if body.is_in_group("player"):
		body.motion = (body.global_position - global_position).normalized() * player_explosion_knockback
	if body.is_in_group("movable"):
		body.apply_central_impulse((body.global_position - global_position).normalized() * player_explosion_knockback * 100)
