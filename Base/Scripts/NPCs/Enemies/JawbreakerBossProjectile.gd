extends KinematicBody2D

var motion := Vector2.ZERO

const SPEED = 300

func _physics_process(delta):
	motion = move_and_slide(motion)
	if motion == Vector2.ZERO:
		queue_free()

func launch(goes_left:bool):
	motion = Vector2.LEFT if goes_left else Vector2.RIGHT
	motion *= SPEED

func _on_Hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(1, motion)
	if !body.is_in_group("enemy") && body != self:
		queue_free()
