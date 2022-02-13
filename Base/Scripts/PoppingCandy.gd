extends Node2D

const COOLDOWN = 1

var rays = []
var sub_ray = load("res://Scenes/SubRay.tscn")
var center_pos
var can_shoot:= true
var locked:= false
var charging:=false

export var enemy_knockback = 0
export var player_knockback = 0.15

func _process(_delta):
	
	if Input.is_action_just_pressed("shoot"):
		visible = true
	if Input.is_action_just_released("shoot"):
		visible = false
	
	if can_shoot:
		if Input.is_action_pressed("shoot"):
			if !charging:
				charging = true
				$ChargeTime.start()
			locked = true
			get_parent().motion.x-= rays.size() * get_parent().facing.x * player_knockback
			for ray in rays:
				ray.activate()
				$Cooldown.start()
				can_shoot = false
				#ray.explosion.visible = true
				#ray.line.visible = true
		else:
			locked = false
			if !charging:
				charging = true
				$ChargeTime.start()
	#else:
		
		#for ray in rays:
			#ray.explosion.visible = false
			#ray.line.visible = false
			#ray.line.scale.y = 2.4
			#ay.explosion.position = ray.cast_to

func launch(direction, strength):
	create_sub_ray(PI/2)
	if direction.x == 1:
		center_pos = -PI/2
	if direction.x == -1:
		center_pos = PI/2
	if direction.y == 1:
		center_pos = 0
	if direction.y == -1:
		center_pos = PI
	rotate(center_pos)

func get_player_max_speed(initial_max_speed):
	return initial_max_speed / (rays.size() * 0.4 + 1)

func create_sub_ray(relative_rotation):
	var temp_ray = sub_ray.instance()
	add_child(temp_ray)
	temp_ray.rotate(relative_rotation)
	rays.append(temp_ray)

func subray_creator():
	match rays.size():
		1:
			create_sub_ray(PI/48 + PI/2)
		2:
			create_sub_ray(-PI/48 + PI/2)
		3:
			create_sub_ray(PI/24 + PI/2)
		4:
			create_sub_ray(-PI/24 + PI/2)
func subray_deleter():
	if rays.size() > 1:
		rays[rays.size()-1].queue_free()
		rays.remove(rays.size()-1)

func _on_Timer_timeout():
	can_shoot = true

func _on_ChargeTime_timeout():
	charging = false
	if locked:
		subray_creator()
	else:
		subray_deleter()
