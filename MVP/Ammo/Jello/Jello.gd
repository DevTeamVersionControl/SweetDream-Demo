extends KinematicBody2D

const GRAVITY = 400.0
const PLAYER_KNOCKBACK = 100
const INITIAL_VELOCITY = 200

onready var animation_player := $AnimationPlayer

var velocity := Vector2.ZERO
var locked := false

func _ready():
	$Timer.start()
	animation_player.play("Bounce")
	animation_player.stop(false)

func _physics_process(delta):
	if !locked:
		velocity.y += GRAVITY/2 * pow(delta * 20, 2)
		var collision = move_and_collide(velocity*delta)
		if collision != null:
			_on_impact(collision.normal)
			animation_player.play("Bounce", -1, 2, false)
			animation_player.advance(3.0*1.0/48.0)
			locked = true
			yield(animation_player, "animation_finished")
			locked = false
			animation_player.play("Bounce")
			animation_player.stop(true)
			animation_player.seek(0, true)

func launch(direction, _strength)->Vector2:
	velocity = direction * INITIAL_VELOCITY + Vector2.UP * 100
	return -velocity.normalized() * PLAYER_KNOCKBACK

func _on_impact(normal):
	velocity = velocity.bounce(normal)
	velocity *= 0.95
	animation_player.play("Bounce")
	animation_player.seek(3.0 * 1.0/24.0, true)

func _on_Area2D_body_entered(body):
	if body.is_in_group("destructable"):
		body.disappear()
		_on_Timer_timeout()
	if body.is_in_group("enemy"):
		body.take_damage(GlobalVars.get_ammo("Jello").damage, Vector2.ZERO)
		_on_Timer_timeout()

func _on_Timer_timeout():
	animation_player.play("Pop", -1, 2, false)
	locked = true
