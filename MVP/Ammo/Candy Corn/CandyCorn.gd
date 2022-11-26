extends Area2D

const COOLDOWN = 0.2
const DAMAGE = 1

export var SPEED = 400

export var enemy_knockback = 0
export var player_knockback = 0

var direction = Vector2.ZERO

func _physics_process(delta):
	position += delta * SPEED * direction

func _on_Hit(body):
	if body.get_collision_layer_bit(0):
		queue_free()
	elif body.get_collision_layer_bit(1):
		body.take_damage(DAMAGE, direction.normalized() * enemy_knockback)
		queue_free()

func set_direction(bullet_direction : Vector2) -> void:
	direction = bullet_direction
	rotation = direction.angle()
