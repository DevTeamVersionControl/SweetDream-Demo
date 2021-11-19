extends Node2D

const COOLDOWN = 1

var rays = []
var sub_ray = load("res://Scenes/SubRay.tscn")
var center_pos
var can_shoot:= true

func _process(_delta):
	if Input.is_action_pressed("shoot"):
		if can_shoot:
			for ray in rays:
				ray.activate()
				$Timer.start()
				can_shoot = false
				ray.explosion.visible = true
				ray.line.visible = true
		else:
			for ray in rays:
				ray.explosion.visible = false
				ray.line.visible = false
				ray.line.scale.y = 1.6

func launch(direction):
	create_sub_ray(PI/24 + PI/2)
	create_sub_ray(PI/2)
	create_sub_ray(-PI/24 + PI/2)
	if direction.x == 1:
		center_pos = -PI/2
	if direction.x == -1:
		center_pos = PI/2
	if direction.y == 1:
		center_pos = 0
	if direction.y == -1:
		center_pos = PI
	rotate(center_pos)

func create_sub_ray(relative_rotation):
	var temp_ray = sub_ray.instance()
	add_child(temp_ray)
	temp_ray.rotate(relative_rotation)
	rays.append(temp_ray)


func _on_Timer_timeout():
	can_shoot = true
