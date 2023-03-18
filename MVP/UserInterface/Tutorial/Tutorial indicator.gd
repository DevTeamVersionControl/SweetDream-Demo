extends Area2D

onready var sprite := get_node_or_null("Sprite")

var save_path = GameSaver.save_path

func _ready(): 
	sprite.visible = false

func _on_Tutorial_indicator_body_entered(body):
	sprite.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "position", Vector2(0,3), 0.6)
	tween.tween_property(sprite, "position", Vector2(0,-3), 0.6)
	tween.set_loops()

func _on_Tutorial_indicator_body_exited(body):
	sprite.visible = false

func save(game_data):
	game_data[get_tree().current_scene.current_level.filename + name] = true

func load(game_data):
	if game_data.has(get_tree().current_scene.current_level.filename + name):
		if game_data.get(get_tree().current_scene.current_level.filename + name):
			queue_free()

func _exit_tree():
	GameSaver.save()
	GameSaver.partial_save(self)
