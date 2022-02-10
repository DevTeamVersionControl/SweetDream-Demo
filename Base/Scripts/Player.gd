extends KinematicBody2D

export var MAX_FALL_SPEED = 120.5
export var MAX_SPEED = 7
export var JUMP_FORCE = 30
export var ACCEL = 1
export var hp := 10
export var gravity := 9.8

const PIXELS_PER_METER = 16
const MAX_BULLET_STRENGTH = 1
const UP = Vector2.UP

var facing = Vector2(1,0)
var bullet_direction = Vector2()
var bullet_strength = 0
var jello = preload("res://Scenes/Jello.tscn")
var candy_corn = preload("res://Scenes/CandyCorn.tscn")
var icing_gun = preload("res://Scenes/IcingGun.tscn")
var jawbreaker = preload("res://Scenes/Jawbreaker.tscn")
var popping_candy = preload("res://Scenes/PoppingCandy.tscn")
var jelly_bean = preload("res://Scenes/JellyBean.tscn")
var ammo = [candy_corn,icing_gun,jawbreaker,popping_candy,jelly_bean]
var equiped_ammo = 0
var can_shoot := true
var invulnerable := false
var screen_size

var motion = Vector2()

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("ammo_next") && can_shoot:
		if equiped_ammo < ammo.size() - 1:
			equiped_ammo += 1
		else:
			equiped_ammo = 0
		print(equiped_ammo)
	if Input.is_action_just_pressed("ammo_last") && can_shoot:
		if equiped_ammo > 0:
			equiped_ammo -= 1
		else:
			equiped_ammo = ammo.size() - 1
		print(equiped_ammo)
	
	if(Input.is_action_just_pressed("shoot")):
		$ShootBar.visible = true
	
	if(Input.is_action_pressed("shoot")):
		if $ShootBar.visible && can_shoot:
			if bullet_strength <= MAX_BULLET_STRENGTH:
				bullet_strength += delta/2
				$ShootBar.scale.x = bullet_strength/20
	
	if(Input.is_action_just_released("shoot")):
		if bullet_strength != 0:
			shoot(ammo[equiped_ammo], bullet_strength)
			bullet_strength = 0
			$ShootBar.visible = false
			$ShootBar.scale.x = 0
	
	motion.y += gravity/2 * pow(delta * 45,2)
	
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
	
	motion = move_and_slide(motion * PIXELS_PER_METER, UP)
	motion /= PIXELS_PER_METER
	
	if bullet_direction.y == 0:
		bullet_direction.x = facing.x
	else:
		bullet_direction.x = 0
	
	if global_position.y > screen_size.y:
		get_tree().reload_current_scene()

func shoot(ammo, strength):
	if can_shoot:
		var bullet = ammo.instance()
		get_tree().current_scene.add_child(bullet)
		bullet_direction = bullet_direction.normalized()
		bullet.global_transform = global_transform
		bullet.launch(bullet_direction, bullet_strength)
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

func _on_BounceBox_area_entered(area):
	if motion.y > 0 && !invulnerable:
		motion.y *= -1.4
		motion.x *= 2
		if area.get_parent().is_in_group("enemy"):
			invulnerable = true
			$InvulnerabilityTimer.start(0.5)
		area.get_parent().bounce()
