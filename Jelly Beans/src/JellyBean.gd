extends KinematicBody2D

const THROW_VELOCITY = Vector2(15,80)
const PIXELS_PER_METER = 16
const GRAVITY = 9.8 * 8
const COOLDOWN = 1

export var strech_speed = 60

var velocity = Vector2.ZERO
var can_move := true

func _physics_process(delta):
	if can_move:
		velocity.y += GRAVITY * delta
		if velocity.x > 0:
			rotation = velocity.angle()
		else: 
			rotation = PI + velocity.angle()
		if velocity.length() < strech_speed:
			$AnimatedSprite.frame = 0
		else:
			$AnimatedSprite.frame = 1
		var collision = move_and_collide(velocity*delta*PIXELS_PER_METER)
		if collision != null:
			explode()
			
func launch(direction):
	velocity = THROW_VELOCITY * direction
	$Timer.start()
func _on_inpact(normal):
	velocity = velocity.bounce(normal)
	velocity *= 0.5

func explode():
	can_move = false
	$Area2D.monitorable = true
	$Area2D.monitoring = true
	$Area2D/Sprite.visible = true
	$AnimatedSprite.visible = false
	yield(get_tree().create_timer(0.2), "timeout")
	$Area2D/Sprite.visible = false
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("destructable"):
		body.disappear()
	if body.is_in_group("enemy"):
		body.take_damage(5)
		body.motion = (body.global_position - global_position)
	if body.is_in_group("player"):
		body.motion = (body.global_position - global_position) * 2
