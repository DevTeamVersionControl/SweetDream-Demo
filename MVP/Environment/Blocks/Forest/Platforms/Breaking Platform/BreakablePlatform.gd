extends StaticBody2D

const BREAK_TIME = 2.0

var can_reappear = true
var should_reappear:= false

var break_level := 0.0

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Player:
			break_level += delta
			if break_level > BREAK_TIME:
				if $AnimationPlayer.current_animation != "stage3":
					$AnimationPlayer.play("stage3")
			elif break_level > BREAK_TIME * 1/2:
				$AnimationPlayer.play("stage2")
			elif break_level > 0.0:
				$AnimationPlayer.play("stage1")

func disappear():
	break_level = 0
	visible = false
	$AnimationPlayer.play("RESET")
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()

func _on_Timer_timeout():
	if !visible:
		if can_reappear:
			reappear()
		else:
			should_reappear = true

func reappear():
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	should_reappear = false

func _on_Area2D_body_entered(body):
	if body is Player:
		$Shaker.play("Shake")
		can_reappear = false

func _on_Area2D_body_exited(body):
	if body is Player:
		$Shaker.stop()
		can_reappear = true
		if should_reappear:
			reappear()
