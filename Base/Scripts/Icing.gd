extends Area2D

const THROW_VELOCITY = 20
const SPLATTER = preload("res://Scenes/IcingSplatter.tscn")
const PIXELS_PER_METER = 16

export var GRAVITY = 9.8

var velocity := Vector2.ZERO

func launch(angle):
	velocity = Vector2(THROW_VELOCITY,0)
	velocity = velocity.rotated(angle)

func _process(delta):
	velocity.y += GRAVITY * pow(delta, 2) * 15 * PIXELS_PER_METER
	global_position += velocity

func _on_Area2D_body_entered(body):
	if body.is_in_group("floor"):
		var splatter = SPLATTER.instance()
		get_tree().current_scene.call_deferred("add_child",splatter)
		splatter.position.x = position.x
		splatter.position.y = body.position.y - 30
	call_deferred("queue_free")
