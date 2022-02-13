extends KinematicBody2D

const PIXELS_PER_METER = 16
const MIN_VOLUME = 0.5
const MAX_VOLUME = 2.86
const NUM_OF_BABIES = 3

var motion = Vector2()
var target
var facing_right := true
var is_on_floor:bool
var volume = MIN_VOLUME
var new_enemy = load("res://Scenes/Enemy.tscn")
var screen_size
export var jump_lenght = 5
export var jump_height = 7.1
export var hp = 10
export var gravity = 9.8

func _ready():
	grow(rand_range(0,1))
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	motion.y += gravity * delta
	if is_on_floor():
		motion.x = lerp(motion.x, 0, 0.1)
	motion = move_and_slide(motion*PIXELS_PER_METER, Vector2(0,-1))
	motion /= PIXELS_PER_METER

func pulse():
	grow(0)
	$Sprite.animation = "Jump"
	yield(get_tree().create_timer(0.5), "timeout")
	motion = target.global_position - global_position
	motion.x = motion.normalized().x * jump_lenght
	motion.y = -jump_height
	if facing_right:
		if motion.x < 0:
			$Sprite.set_deferred("scale", Vector2($Sprite.scale.x * -1, $Sprite.scale.y))
			facing_right = false
	else:
		if motion.x > 0:
			$Sprite.set_deferred("scale", Vector2($Sprite.scale.x * -1, $Sprite.scale.y))
			facing_right = true
	if (global_position.y > screen_size.y || global_position.x > screen_size.x || global_position.x < 0):
		queue_free()
	yield($Sprite, "animation_finished")
	$Sprite.animation = "Idle"
	
func take_damage(damage, knockback):
	hp -= damage
	motion += knockback
	if hp <= 0:
		$Sprite.animation = "Death"
		yield($Sprite, "animation_finished")
		queue_free()
	else:
		$Sprite.animation = "HitOnGround"
		yield($Sprite, "animation_finished")

func grow(add_volume):
	volume += add_volume
	if volume > MAX_VOLUME:
		for n in NUM_OF_BABIES:
			var new_baby = new_enemy.instance()
			get_tree().current_scene.call_deferred("add_child", new_baby)
			new_baby.global_position = global_position + Vector2(-5 + n*5,0)
			new_baby.target = target
		queue_free()
	set_deferred("scale", Vector2(volume,volume))
	
func bounce():
	$Sprite.animation = "HitOnGround"
	$Sprite.set_speed_scale(3)
	yield($Sprite, "animation_finished")
	$Sprite.set_speed_scale(1)
	$Sprite.animation = "Idle"
