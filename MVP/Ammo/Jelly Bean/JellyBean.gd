extends KinematicBody2D

export var THROW_VELOCITY = 80
export var THROW_ANGLE = 30
const PIXELS_PER_METER = 16
export var GRAVITY = 9.8
const COOLDOWN = 1
const DAMAGE = 5
export var enemy_knockback = 10
export var player_knockback = 5
export var player_explosion_knockback = 10

export var strech_speed = 60

var velocity = Vector2.ZERO
var can_move := true

func _physics_process(delta):
	if can_move:
		velocity.y += GRAVITY * delta
		#if velocity.length() > 5 || velocity.length() < -5:
		#	if velocity.x > 0:
		#		rotation = velocity.angle()
		#	else: 
		#		rotation = PI + velocity.angle()
		if velocity.length() < strech_speed && velocity.length() > -strech_speed:
			$AnimatedSprite.frame = 0
		else:
			$AnimatedSprite.frame = 1
		var collision = move_and_collide(velocity*delta*PIXELS_PER_METER, false)
		if collision != null:
			_on_inpact(collision.normal)
			
func launch(direction, strength):
	if direction.x == 1:
		velocity = Vector2(cos(deg2rad(THROW_ANGLE)),sin(deg2rad(THROW_ANGLE))) * THROW_VELOCITY
	elif direction.x == -1:
		velocity = Vector2(cos(deg2rad(180 - THROW_ANGLE)),sin(deg2rad(180 - THROW_ANGLE))) * THROW_VELOCITY
	velocity.y *= -1
	get_parent().motion += -velocity.normalized() * player_knockback
	$ExplosionTimer.start()
	var scene = get_tree().current_scene
	var pos = global_position
	get_parent().remove_child(self)
	scene.add_child(self)
	global_position = pos

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
		body.take_damage(DAMAGE, (body.global_position - global_position).normalized() * enemy_knockback)
	if body.is_in_group("player"):
		body.motion = (body.global_position - global_position).normalized() * player_explosion_knockback
	if body.is_in_group("movable"):
		body.apply_central_impulse((body.global_position - global_position).normalized() * player_explosion_knockback * 100)


func _on_Timer_timeout():
	explode()
