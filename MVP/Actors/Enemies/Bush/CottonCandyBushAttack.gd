extends Area2D

const SPEED = 0.2
const MAX_SPEED = 5

var target
var motion = Vector2.ZERO

func _physics_process(delta):
	motion.x = lerp(motion.x, 0, 0.1)
	motion.y = lerp(motion.y, 0, 0.1)
	motion += ((target.global_position + Vector2(0,-10)) - global_position).normalized() * SPEED
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)
	global_position = global_position + motion

func _on_CottonCandyBushAttack_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(2, motion)
	if !body.is_in_group("enemy"):
		queue_free()

func launch(direction:Vector2):
	motion += direction


func _on_Timer_timeout():
	queue_free()
