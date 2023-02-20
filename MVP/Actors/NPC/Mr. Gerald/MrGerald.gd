extends Sprite

onready var animation_player = $AnimationPlayer

var player_is_in_zone := false
var in_dialog := false

func _ready():
	animation_player.play("Idle")
	get_tree().current_scene.gui.dialog.connect("talk", self, "on_talk")
	get_tree().current_scene.gui.dialog.connect("shop", self, "on_shop")

func _unhandled_key_input(_event):
	if Input.is_action_pressed("interact") && player_is_in_zone && !in_dialog:
		get_tree().current_scene.start_dialog("res://UserInterface/Dialog/Json/MrGerald.json")
		in_dialog = true

func _on_InteractionBox_body_entered(body):
	if body is Player:
		player_is_in_zone = true

func _on_InteractionBox_body_exited(body):
	if body is Player:
		player_is_in_zone = false

func on_talk():
	if in_dialog:
		animation_player.play("Speak")

func on_shop():
	get_tree().current_scene.start_shop("res://UserInterface/Shops/Json/MrGerald.json")
	yield(get_tree().current_scene.gui.shop, "dialog_end")
	in_dialog = false
