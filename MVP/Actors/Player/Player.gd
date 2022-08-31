class_name Player
extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 120
var gravity = 1200
var jump_impulse = 400
var jump_accel = 600
var level_limit = Vector2(1920, 1080)

func _physics_process(delta):
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _shoot():
	
