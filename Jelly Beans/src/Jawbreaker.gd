extends KinematicBody2D

const THROW_VELOCITY = Vector2(15,80)
const PIXELS_PER_METER = 16
const GRAVITY = 9.8 * 8
const COOLDOWN = 1

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	var collision = move_and_collide(velocity*delta*PIXELS_PER_METER)
	if collision != null:
		_on_inpact(collision.normal)
		
func launch(direction):
	velocity = THROW_VELOCITY * direction
	$Timer.start()
func _on_inpact(normal):
	velocity = velocity.bounce(normal)
	velocity *= 0.5



func _on_Area2D_body_entered(body):
	if body.is_in_group("destructable"):
		body.disappear()


func _on_Timer_timeout():
	queue_free()
