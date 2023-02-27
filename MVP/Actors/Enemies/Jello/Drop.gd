extends JelloEnemyState

func enter(msg={}):
	jello.get_node("CollisionShape2D2").disabled = true
	yield(get_tree().create_timer(0.2), "timeout")
	jello.get_node("CollisionShape2D2").disabled = false

func physics_process(delta):
	jello.motion.y += jello.GRAVITY
	jello.motion.x = lerp(jello.motion.x, 0, 0.2)
	jello.motion = jello.move_and_slide(jello.motion)
