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
	if body.is_in_group("enemy"):
		body.take_damage(DAMAGE, direction.normalized() * enemy_knockback)
		queue_free()
	if body.is_in_group("floor"):
		queue_free()

func set_direction(bullet_direction : Vector2) -> void:
	direction = bullet_direction
	rotation = direction.angle()
