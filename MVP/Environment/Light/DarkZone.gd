extends Area2D

onready var animation_player := $AnimationPlayer

var save_path = GameSaver.save_path
var delete := false 

func _on_DarkZone_body_entered(body):
	if body is Player:
		animation_player.play("FadeOut")

func _on_DarkZone_body_exited(body):
	if body is Player:
		animation_player.play("FadeIn")

func save(game_data):
	game_data[get_tree().current_scene.current_level.filename + name] = delete

func load(game_data):
	if game_data.has(get_tree().current_scene.current_level.filename + name):
		if game_data.get(get_tree().current_scene.current_level.filename + name):
			queue_free()

func disappear():
	GameSaver.partial_save(self)
	delete = true
	queue_free()
