extends KinematicBody2D

const PIXELS_PER_METER = 16

export var launch_direction = Vector2(20,-2)
export var gravity := 9.8
var volume:= 0.5

func grow(add_volume):
	volume += add_volume
	set_deferred("scale", Vector2(volume,volume))
	
func bounce():
	$AnimatedSprite.playing = true
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.playing = false
