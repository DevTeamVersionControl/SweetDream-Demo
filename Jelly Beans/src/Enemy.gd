extends RigidBody2D

const GRAVITY = 9.8
const PIXELS_PER_METER = 16
const UP = Vector2(0,-1)

var motion = Vector2()
var target

func pulse():
	linear_velocity = (target.global_position - global_position + Vector2(0,-200)) * 0.3
