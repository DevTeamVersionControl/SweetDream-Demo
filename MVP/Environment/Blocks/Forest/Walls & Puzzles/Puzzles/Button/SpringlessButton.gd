tool
extends Area2D

signal on
signal off

export var colour:int setget set_colour

var bodies := 0
var on := false

func _on_Area2D_body_entered(body):
	if body.is_in_group("pushbutton"):
		if bodies < 0:
			bodies = 0
		bodies += 1
		emit_signal("on")
		on = true
		$Sprite.frame = 1 + colour * 2
		$Sprite.position.y = 0

func set_colour(new_colour):
	colour = new_colour
	$Sprite.frame = 0 + colour * 2
	$Sprite.position.y = -3
