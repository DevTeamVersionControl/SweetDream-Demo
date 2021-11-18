extends Node2D

func _ready():
	var parent = get_parent()
	

func shoot(direction):
	if direction.x == 1:
		rotation = -PI/4
	if direction.x == -1:
		rotation = PI/4
	if direction.y == 1:
		rotation = PI
	if direction.y == -1:
		rotation = 0
