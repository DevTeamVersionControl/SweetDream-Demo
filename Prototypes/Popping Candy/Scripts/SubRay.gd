#https://www.youtube.com/watch?v=lNADi7kTDJ4
extends RayCast2D

var body
var collision
onready var explosion = $Impact
onready var line = $Line

func activate():
	if is_colliding():
		collision = get_collision_point()
		body = get_collider()
		if body:
			if body.is_in_group("enemy"):
				body.take_damage(1)
			line.scale.y = (collision-get_parent().global_position).length()/50
			explosion.global_position = collision
