extends StaticBody2D

var can_reappear = true
var should_reappear:= false

func disappear():
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()

func _on_Timer_timeout():
	if can_reappear:
		reappear()
	else:
		should_reappear = true

func reappear():
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	should_reappear = true

func _on_Area2D_body_entered(body):
	if body is Player:
		can_reappear = false

func _on_Area2D_body_exited(body):
	if body is Player:
		can_reappear = true
		if should_reappear:
			reappear()
