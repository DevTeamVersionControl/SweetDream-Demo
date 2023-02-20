tool
extends Area2D

signal on
signal off

export var colour:int setget set_colour
  
var bodies := 0
var on := false

func _on_Area2D_body_entered(body):
	if body.is_in_group("pushbutton") && !on:
		push()

func set_colour(new_colour):
	colour = new_colour
	$Sprite.frame = 0 + colour * 2
	$Sprite.position.y = -3

func save(game_data:Dictionary):
	print(get_tree().current_scene.current_level.filename)
	game_data[get_tree().current_scene.current_level.filename + name] = on

func load(game_data):
	print(get_tree().current_scene.current_level.name)
	if game_data.has(get_tree().current_scene.current_level.filename + name):
		push()

func push():
	emit_signal("on")
	on = true
	$Sprite.frame = 1 + colour * 2
	$Sprite.position.y = 0
	GameSaver.save()
