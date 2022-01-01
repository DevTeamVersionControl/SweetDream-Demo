extends KinematicBody2D

const PIXELS_PER_METER = 16

var motion = Vector2()
var target
var is_on_floor:bool
export var speed = 5
export var jump_height = 8
export var hp = 10

func _physics_process(delta):
	motion.y += get_tree().current_scene.GRAVITY*delta
	if is_on_floor():
		motion.x = lerp(motion.x, 0, 0.1)
	motion = move_and_slide(motion*PIXELS_PER_METER, Vector2(0,-1))
	motion /= PIXELS_PER_METER

func pulse():
	$Sprite.animation = "Jump"
	yield(get_tree().create_timer(0.5), "timeout")
	motion = target.global_position - global_position
	motion.x = motion.normalized().x * speed
	motion.y = -jump_height
	if (global_position.y > get_parent().screen_size.y || global_position.x > get_parent().screen_size.x || global_position.x < 0):
		queue_free()
	yield($Sprite, "animation_finished")
	$Sprite.animation = "Idle"
	
func take_damage(damage):
	hp -= damage
	if hp <= 0:
		$Sprite.animation = "Death"
		yield($Sprite, "animation_finished")
		queue_free()
	else:
		$Sprite.animation = "HitOnGround"
		yield($Sprite, "animation_finished")
