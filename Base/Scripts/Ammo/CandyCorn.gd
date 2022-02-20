extends Area2D

export var COOLDOWN = 0.2
export var enemy_knockback = 0
export var player_knockback = 0

export var speed = 400
var velocity


func _physics_process(delta):
	position += velocity * delta * speed

func launch(direction, strength):
	velocity = direction
	rotation = atan2(-direction.x, direction.y) + PI/2
	get_parent().motion += -velocity.normalized() * player_knockback
	var scene = get_tree().current_scene
	var pos = global_position
	get_parent().remove_child(self)
	scene.add_child(self)
	global_position = pos


func _on_Hit(body):
	if body.is_in_group("enemy"):
		body.take_damage(2, velocity.normalized() * enemy_knockback)
		queue_free()
	if body.is_in_group("floor"):
		queue_free()


func _on_StrechTimer_timeout():
	$Sprite.frame = 1
