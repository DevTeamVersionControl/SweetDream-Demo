extends Node2D

signal my_signal(value, other_value)

func _ready():
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	emit_signal("my_signal", true, 42)

func _on_Timer_timeout():
	$Sprite.visible = !$Sprite.visible
