class_name Player
extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 120
var gravity = 1200
var jump_impulse = 400
var jump_accel = 600
var level_limit = Vector2(1920, 1080)

func _process(_delta):
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
