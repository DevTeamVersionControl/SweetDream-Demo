#https://www.youtube.com/watch?v=p6OQ7XVsiKw
extends KinematicBody2D

const MAX_FALL_SPEED = 120.5
const MAX_SPEED = 7
const JUMP_FORCE = 30
const ACCEL = 1
const MAX_BULLET_STRENGTH = 1

var facing = Vector2(1,0)
var bullet_direction = Vector2()
var bullet_strength = 0
var hp := 10
var equiped_ammo
var can_shoot := true
var invulnerable := false

var motion = Vector2()

func _physics_process(delta):
	
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
	
	if(Input.is_action_just_pressed("shoot")):
		if can_shoot && equiped_ammo != null:
			shoot(equiped_ammo, equiped_ammo.strength)
	
	motion.y += get_parent().GRAVITY/2 * pow(delta * 45,2)
	
	if (Input.is_action_pressed("up")):
		bullet_direction.y = -1
	elif (Input.is_action_pressed("down")):
		bullet_direction.y = 1
	else:
		bullet_direction.y = 0
	
	if motion.y > MAX_FALL_SPEED:
		motion.y = MAX_FALL_SPEED
	
	if (Input.is_action_pressed("right")):
		motion.x += ACCEL
		facing.x = 1
	elif (Input.is_action_pressed("left")):
		motion.x -= ACCEL
		facing.x = -1
	else:
		motion.x = lerp(motion.x, 0, 0.2)
	
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	
	if is_on_floor():
		if (Input.is_action_just_pressed("jump")):
			motion.y = -JUMP_FORCE
	
	motion = move_and_slide(motion * get_parent().PIXELS_PER_METER,get_parent().UP)
	motion /= get_parent().PIXELS_PER_METER
	
	if bullet_direction.y == 0:
		bullet_direction.x = facing.x
	else:
		bullet_direction.x = 0
	
	if global_position.y > get_parent().screen_size.y:
		get_tree().reload_current_scene()

func shoot(ammo, strength):
	if can_shoot:
		var bullet = ammo.instance()
		get_tree().current_scene.add_child(bullet)
		bullet.global_transform = global_transform
		bullet_direction = bullet_direction.normalized() * bullet_strength
		bullet.launch(bullet_direction)
		can_shoot = false
		$AmmoTimer.start(bullet.COOLDOWN)

func take_damage(damage, direction):
	hp -= damage
	motion.x += direction.x * 4
	if hp <= 0:
		get_tree().reload_current_scene()
	invulnerable = true
	$AnimatedSprite.playing = true
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.playing = false
	$AnimatedSprite.frame = 0
	invulnerable = false

func _on_AmmoTimer_timeout():
	can_shoot = true


func _on_Area2D_body_entered(body):
	if body.is_in_group("destructable"):
		body.can_reappear = false
	if body.is_in_group("enemy"):
		if !invulnerable:
			take_damage(2, body.motion)


func _on_Area2D_body_exited(body):
	if body.is_in_group("destructable"):
		body.can_reappear = true
		if body.should_reappear:
			body.reappear()


func _on_InvulnerabilityTimer_timeout():
	invulnerable = false