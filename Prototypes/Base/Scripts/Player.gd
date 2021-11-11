extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const MAX_FALL_SPEED = 200
const MAX_SPEED = 80
const JUMP_FORCE = 300
const ACCEL = 20

var motion = Vector2()

func _ready():
	pass

func _physics_process(delta):
	
	motion.y += GRAVITY
	if motion.y > MAX_FALL_SPEED:
		motion.y = MAX_FALL_SPEED
	
	if (Input.is_action_pressed("right")):
		motion.x += ACCEL
	elif (Input.is_action_pressed("left")):
		motion.x -= ACCEL
	else:
		motion.x = lerp(motion.x, 0, 0.2)
	
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	
	if is_on_floor():
		if (Input.is_action_just_pressed("jump")):
			motion.y = -JUMP_FORCE
	
	motion = move_and_slide(motion,UP)
