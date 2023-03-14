extends Sprite

onready var animation_player = $AnimationPlayer

var player_is_in_zone := false
var in_dialog := false

func _ready():
	animation_player.play("Idle")
	get_tree().current_scene.gui.dialog.connect("talk", self, "on_talk")
	get_tree().current_scene.gui.dialog.connect("shop", self, "on_shop")
	get_tree().current_scene.gui.dialog.connect("equip_candy_corn", self, "equip_candy_corn")

func _unhandled_key_input(_event):
	if Input.is_action_pressed("interact") && player_is_in_zone && !get_tree().current_scene.gui.dialog.visible && !get_tree().current_scene.gui.shop.visible:
		get_tree().current_scene.start_dialog("res://UserInterface/Dialog/Json/MrGerald.json", get_dialog_num())
		in_dialog = true
		yield(get_tree().current_scene.gui.dialog, "dialog_end")
		in_dialog = false

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
	get_tree().current_scene.start_shop("res://UserInterface/Shops/Json/Birb.json")
	get_tree().current_scene.gui.dialog.close_dialog()
	yield(get_tree().current_scene.gui.shop, "dialog_end")
	in_dialog = false

# Returns the point at the conversation the dialog should be
func get_dialog_num() -> int:
	for item in GlobalVars.inventory:
		if item.has("StoryPoint"):
			var story_point = int(item.get("StoryPoint"))
			if item.has("Temporary"):
				item.erase("StoryPoint")
				item.erase("Temporary")
			return story_point
	return 0
