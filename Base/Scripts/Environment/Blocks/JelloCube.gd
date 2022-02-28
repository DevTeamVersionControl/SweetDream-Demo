extends KinematicBody2D

const PIXELS_PER_METER = 16

export var gravity := 9.8
export var volume = 0.5
var motion = Vector2.ZERO

func _physics_process(delta):
	motion.y += gravity * delta
	motion = move_and_slide(motion)

func grow(add_volume):
	volume += add_volume
	set_deferred("scale", Vector2(volume,volume))
	
func bounce():
	$AnimatedSprite.playing = true
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.playing = false
