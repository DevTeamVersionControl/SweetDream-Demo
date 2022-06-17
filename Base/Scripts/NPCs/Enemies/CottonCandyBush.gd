extends KinematicBody2D

signal update

enum states {idle, walking, attacking, turning}
enum aggro_states {asleep, falling_asleep, waking_up, awake}

const MAX_AGRESSIVENESS = 5
const TURN_TIME = 1.0
const SPEED = 5
const ROOT_TRIGGER_ATTACK_TIME = 2.0
const ROOT_ATTACK_WARNING_TIME = 1.0
const ROOT_ATTACK_TIME = 0.2

var state = states.idle
var aggro_state = aggro_states.asleep
var aggressiveness := 0.0
var root_attack_timer := 0.0
var root_attack := false
var facing = 1
var hp = 20

var motion = Vector2.ZERO
var target


func _ready():
	pass

func _physics_process(delta):
	match aggro_state:
		aggro_states.asleep: $AnimatedSprite.frame = 0
		aggro_states.falling_asleep: 
			if aggressiveness > 0:
				aggressiveness -= delta
			else:
				fall_asleep()
		aggro_states.waking_up: 
			if aggressiveness >= MAX_AGRESSIVENESS:
				wake_up()
			else:
				aggressiveness += delta
		aggro_states.awake: pass
	match state:
		states.idle: motion.x = 0
		states.walking: 
			walk()
			if root_attack:
				if root_attack_timer >= ROOT_TRIGGER_ATTACK_TIME:
					attack()
				else:
					root_attack_timer += delta
			else:
				if root_attack_timer > 0:
					root_attack_timer -= delta
		states.turning: motion.x = 0
		states.attacking: 
			if root_attack:
				target.take_damage(4, Vector2(facing, 0))
	motion.y += 9.8
	motion.x = lerp(motion.x, 0, 0.2)
	motion = move_and_slide(motion, Vector2.UP)
	emit_signal("update", state)

func wake_up():
	$AnimatedSprite.frame = 1
	$AnimatedSprite.scale = Vector2(0.035,0.12)
	$AnimatedSprite.position = Vector2(0, -22)
	$PlayerDetector/DetectionZone.scale = Vector2(10,10)
	$RootHitBox.monitoring = true
	$RootHitBox.monitorable = true
	aggro_state = aggro_states.awake
	state = states.walking
	
func fall_asleep():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.scale = Vector2(0.03,0.05)
	$AnimatedSprite.position = Vector2(0, 0)
	$PlayerDetector/DetectionZone.scale = Vector2(5,5)
	$RootHitBox.set_deferred("monitoring", false)
	$RootHitBox.set_deferred("monitorable", false)
	aggro_state = aggro_states.asleep
	state = states.idle

func walk():
	if (1 if target.global_position.x - global_position.x > 0 else -1) != facing && state != states.turning:
		turn_around()
	motion.x = facing * SPEED
	
func turn_around():
	state = states.turning
	yield(get_tree().create_timer(TURN_TIME), "timeout")
	facing *= -1
	scale.x *= -1
	state = states.walking

func attack():
	state = states.idle
	$RootHitBox/RootHitZone/AnimatedSprite.visible = true
	yield(get_tree().create_timer(ROOT_ATTACK_WARNING_TIME), "timeout")
	$RootHitBox/RootHitZone/AnimatedSprite.frame = 1
	state = states.attacking
	yield(get_tree().create_timer(ROOT_ATTACK_TIME), "timeout")
	state = states.walking
	$RootHitBox/RootHitZone/AnimatedSprite.frame = 0
	$RootHitBox/RootHitZone/AnimatedSprite.visible = false
	root_attack_timer = 0

func take_damage(damage, knockback):
	aggressiveness = MAX_AGRESSIVENESS
	if target == null:
		wake_up()
		target = get_tree().current_scene.player
	hp -= damage
	motion += knockback
	if hp <= 0:
		fall_asleep()
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
	else:
		$AnimatedSprite.animation = "hit"
		$AnimatedSprite.playing = true
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.animation = "default"
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 1

func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("player"):
		aggro_state = aggro_states.waking_up
		target = body

func _on_PlayerDetector_body_exited(body):
	if body.is_in_group("player"):
		aggro_state = aggro_states.falling_asleep


func _on_RootHitBox_body_entered(body):
	if body.is_in_group("player"):
		root_attack = true


func _on_RootHitBox_body_exited(body):
	if body.is_in_group("player"):
		root_attack = false
