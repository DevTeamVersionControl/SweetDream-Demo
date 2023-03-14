extends Area2D

func _on_Spikes_body_entered(body):
	if body is Player:
		body.take_damage(20,Vector2.ZERO)
