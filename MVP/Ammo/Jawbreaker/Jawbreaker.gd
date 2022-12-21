extends KinematicBody2D

export var THROW_velocity = 50
export var THROW_ANGLE = 0
export var COOLDOWN = 1
const PIXELS_PER_METER = 16
export var gravity = 9.8
var touched_something:= false

export var enemy_knockback = 10
export var player_knockback = 10

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += gravity/2 * pow(delta * 20, 2)
	var collision = move_and_collide(velocity*delta*PIXELS_PER_METER)
	if velocity.length() > 5 || velocity.length() < -5:
			if velocity.x > 0:
				rotation = velocity.angle()
			else: 
				rotation = PI + velocity.angle()
	if collision != null:
		if !touched_something:
			$Timer.start()
			touched_something = true
		_on_inpact(collision.normal)
		
func launch(direction, strength)->Vector2:
	if direction.x == 1:
		velocity = Vector2(cos(deg2rad(THROW_ANGLE)),sin(deg2rad(THROW_ANGLE))) * THROW_velocity
	elif direction.x == -1:
		velocity = Vector2(cos(deg2rad(180 - THROW_ANGLE)),sin(deg2rad(180 - THROW_ANGLE))) * THROW_velocity
	velocity *= Vector2(strength, -strength)
	return -velocity.normalized() * player_knockback

func _on_inpact(normal):
	velocity = velocity.bounce(normal)
	velocity *= 0.8

func _on_Area2D_body_entered(body):
	if body.is_in_group("destructable"):
		body.disappear()
		queue_free()
	if body.is_in_group("enemy"):
		body.take_damage(GlobalVars.get_ammo("Jawbreaker").damage, velocity.normalized() * enemy_knockback)

func _on_Timer_timeout():
	queue_free()
