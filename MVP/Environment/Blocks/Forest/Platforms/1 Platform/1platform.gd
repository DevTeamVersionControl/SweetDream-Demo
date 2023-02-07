extends KinematicBody2D

func _ready():
	$AnimationPlayer.play("Up")

func _on_Area2D_body_entered(body):
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Down")

func _on_Area2D_body_exited(body):
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Up")
