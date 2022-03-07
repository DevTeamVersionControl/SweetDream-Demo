extends Area2D

signal on
signal off

var bodies := 0
var on := false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") || body.is_in_group("movable"):
		if bodies < 0:
			bodies = 0
		bodies += 1
		emit_signal("on")
		on = true
		$Sprite.frame = 1


func _on_Button_body_exited(body):
	if body.is_in_group("player") || body.is_in_group("movable"):
		bodies -= 1
		if bodies < 1:
			emit_signal("off")
			on = false
			$Sprite.frame = 0
