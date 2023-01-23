extends KinematicBody2D

var motion : Vector2
var moving = false

func _ready():
	$AnimationPlayer.play("Fly")
	if motion.x < 0:
		$Sprite.flip_h = true

func _physics_process(delta):
	if moving:
		var collision = move_and_collide(motion * delta)
		if collision:
			motion = Vector2.ZERO
			$AnimationPlayer.play("Disappear")

func _on_Area2D_body_entered(body):
	if body is Player:
		body.take_damage(5, motion)

func start_moving():
	moving = true
