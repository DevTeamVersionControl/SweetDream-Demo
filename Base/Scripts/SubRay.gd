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
				body.take_damage(0.5, Vector2.RIGHT.rotated(rotation) * get_parent().enemy_knockback)
				print(Vector2.RIGHT.rotated(rotation + PI/2) * get_parent().enemy_knockback)
			#line.scale.x = (collision-get_parent().global_position).length()/(150)
			#explosion.global_position = collision
