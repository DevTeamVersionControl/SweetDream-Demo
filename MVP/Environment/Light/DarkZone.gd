extends Area2D

onready var animation_player := $AnimationPlayer



func _on_DarkZone_body_entered(body):
	if body is Player:
		animation_player.play("FadeOut")


func _on_DarkZone_body_exited(body):
	if body is Player:
		animation_player.play("FadeIn")
