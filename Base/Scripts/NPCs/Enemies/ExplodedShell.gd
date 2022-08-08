extends Area2D

const SPEED = 500

var active := false

func _physics_process(delta):
	if active:
		global_position.y += SPEED * delta

func _on_ExplodedShell_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(1, Vector2.ZERO)
	if !body.is_in_group("enemy") && body != self && active:
		queue_free()

func activate(time):
	yield(get_tree().create_timer(time), "timeout")
	active = true
