extends KinematicBody2D

const color_path = "res://Actors/Enemies/Bosses/Jaw Breaker/Projectile/Color {str}/Color {str}720p.png"
const color_normal_path = "res://Actors/Enemies/Bosses/Jaw Breaker/Projectile/Color 1/Color 1720p_n.png"

var motion : Vector2
var moving = false

func _ready():
	$Sprite.texture = load(color_path.format({"str": (randi() % 3) + 1}))
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
