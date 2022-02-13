extends KinematicBody2D

export var COOLDOWN = 2
export var CUBE_SPAWN_MIN_VOLUME = 0.4
const PIXELS_PER_METER = 16
const JELLO_CUBE = preload("res://Scenes/JelloCube.tscn")

export var launch_direction = Vector2(20,-10)
export var gravity := 9.8
var volume:= 0.0
var velocity = Vector2.ZERO


func _physics_process(delta):
	velocity.y += gravity/2 * pow(delta * 20, 2)
	velocity = move_and_slide(velocity*PIXELS_PER_METER)
	velocity /= PIXELS_PER_METER
	rotation = velocity.angle()
		
func launch(direction, strenght):
	velocity = launch_direction * strenght
	velocity.x *= direction.x
	grow(strenght)
	var scene = get_tree().current_scene
	var pos = global_position
	get_parent().remove_child(self)
	scene.add_child(self)
	global_position = pos

func grow(add_volume):
	volume += add_volume/2
	set_deferred("scale", Vector2(volume,volume))

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		if body.is_in_group("jello"):
			body.grow(volume)
		else:
			body.take_damage(volume * velocity.length(), Vector2.ZERO)
		queue_free()
	elif body.is_in_group("floor"):
		if velocity.y > 0:
			if volume > CUBE_SPAWN_MIN_VOLUME:
				var new_cube = JELLO_CUBE.instance()
				get_tree().current_scene.call_deferred("add_child", new_cube)
				new_cube.global_position = global_position
				new_cube.grow(volume)
			queue_free()
