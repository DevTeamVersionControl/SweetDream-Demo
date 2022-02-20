extends Area2D

signal on

var on := false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") || body.is_in_group("movable"):
		emit_signal("on")
		on = true
		$Sprite.frame = 1

