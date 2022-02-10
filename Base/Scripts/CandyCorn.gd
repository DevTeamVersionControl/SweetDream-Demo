extends Area2D

export var COOLDOWN = 0.2

export var speed = 400
export var knockback_strength = 5
var velocity


func _physics_process(delta):
	position += velocity * delta * speed

func launch(direction):
	velocity = direction
	rotation = atan2(-direction.x, direction.y) + PI/2


func _on_Hit(body):
	if body.is_in_group("enemy"):
		body.take_damage(2)
		queue_free()
	if body.is_in_group("floor"):
		queue_free()


func _on_StrechTimer_timeout():
	$Sprite.frame = 1
