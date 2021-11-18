extends Area2D

const COOLDOWN = 0.2

export var speed = 400
var velocity
var knockback_strength = 5

func _process(delta):
	position += velocity * delta * speed

func launch(direction):
	velocity = direction
	rotation = atan2(-direction.x, direction.y) + PI/2


func _on_Hit(body):
	if body.is_in_group("enemy"):
		body.take_damage(2)
		queue_free()
