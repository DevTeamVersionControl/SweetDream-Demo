extends KinematicBody2D

signal died

const PIXELS_PER_METER = 16
const MAX_SPEED = 600
const DECEL = 0.1
const CHARGE_TIME = 1
const IDLE_TIME = 1
const TELEGRAPH_TIME = 2

var motion = Vector2()
var target
var facing_right := true
var is_on_floor:bool
var screen_size
var facing := 1
var state = states.idle
export var hp = 10
export var gravity = 9.8
enum states {idle, telegraphing, charging}

func _physics_process(delta):
	match state:
		states.idle: motion.x = lerp(motion.x, 0, DECEL)
		states.telegraphing: return
		states.charging: pass
	motion.y += gravity
	motion = move_and_slide(motion)
	
func charge():
	if state == states.telegraphing:
		state = states.charging
		motion.x = MAX_SPEED * facing
		$AnimatedSprite.play("Charge")
		yield(get_tree().create_timer(CHARGE_TIME), "timeout")
		wait()
	
func aim():
	if state == states.idle:
		state = states.telegraphing
		$AnimatedSprite.play("Telegraph")
		yield(get_tree().create_timer(TELEGRAPH_TIME), "timeout")
		if (1 if target.global_position.x - global_position.x > 0 else -1) != facing:
			scale.x *= -1
			facing *= -1
		charge()

func wait():
	if state == states.charging:
		state = states.idle
		$AnimatedSprite.play("Idle")
		yield(get_tree().create_timer(IDLE_TIME), "timeout")
		aim()
		
func take_damage(damage, knockback):
	hp -= damage
	motion += knockback
	if hp <= 0:
		state = states.telegraphing
		call_deferred("set_collision_layer_bit", 3, false)
		$CollisionShape2D.set_deferred("disabled", true)
		set_physics_process(false)
		$AnimatedSprite.animation = "Death"
		yield($AnimatedSprite, "animation_finished")
		emit_signal("died")
		queue_free()
	else:
		$AnimatedSprite.animation = "Hit"
		yield($AnimatedSprite, "animation_finished")

func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("player"):
		target = body
		aim()
