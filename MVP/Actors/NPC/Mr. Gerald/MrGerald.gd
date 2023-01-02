extends Sprite

onready var animation_player = $AnimationPlayer

var player_is_in_zone := false

func _ready():
	animation_player.play("Idle")

func _unhandled_key_input(_event):
	if Input.is_action_pressed("interact") && player_is_in_zone:
		get_tree().current_scene.start_dialog("res://UserInterface/Dialog/Json/Dialog.json")
		animation_player.play("Speak")
		yield(animation_player, "animation_finished")
		animation_player.play("Idle")

func _on_InteractionBox_body_entered(body):
	if body is Player:
		player_is_in_zone = true

func _on_InteractionBox_body_exited(body):
	if body is Player:
		player_is_in_zone = false
