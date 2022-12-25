extends KinematicBody2D

var motion := Vector2.ZERO

var player : Player
var locked := false

func move_with_player(player_motion):
	motion = player_motion

func _physics_process(_delta):
	if player != null && !locked:
		if (!(global_position.x - player.global_position.x) < 0 == player.facing_right):
			player.velocity.x *= 0.5
			motion.x = player.velocity.x * 2
	motion.y += 4
	motion = move_and_slide(motion)
	motion.x = lerp(motion.x, 0, 0.1)

func _on_Area2D_body_entered(body):
	if body.is_in_group("floor") || body.is_in_group("wall"):
		locked = true
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
	elif body is Player && !locked:
		player = body
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
	


func _on_Area2D_body_exited(body):
	if body.is_in_group("floor") || body.is_in_group("wall"):
		locked = false
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
	if body is Player:
		player = null
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
