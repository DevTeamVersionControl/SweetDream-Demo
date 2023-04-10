tool
extends Area2D

var description = {"Ammo": null,"Description": "An extremely hard candy that can shatter enemies and brittle objects alike","Icon": "res://Pickups/Jaw Breaker 720p.png","Name": "Jawbreaker","StoryPoint": [ "Birb", 2 ],"Temporary": null,"Unit": "artifacts"}
export var sprite_num = 0 setget change_animation

var delete := false 
var save_path
var rads := 0.0
var disappear := false

onready var sprite := $Sprite
onready var timer := $Timer

func _ready():
	description = {"Ammo": null,"Description": "An extremely hard candy that can shatter enemies and brittle objects alike","Icon": "res://Pickups/Jaw Breaker 720p.png","Name": "Jawbreaker","StoryPoint": [ "Birb", 2 ],"Temporary": null,"Unit": "artifacts"}
	sprite.frame = sprite_num
	if description.has("Icon"):
		sprite.queue_free()
		sprite = Sprite.new()
		add_child(sprite)
		sprite.hframes = 1
		sprite.vframes = 1
		sprite.frame = 0
		sprite.texture = load(description.get("Icon"))
		sprite.update()
	if not Engine.is_editor_hint():
		save_path = GameSaver.save_path
		if disappear:
			timer.start()

func _on_Artifact_body_entered(body):
	if body is Player and not Engine.is_editor_hint():
		GlobalVars.add_to_inventory(description)
		disappear()
		GameSaver.save()

func save(game_data):
	if not Engine.is_editor_hint():
		game_data[get_tree().current_scene.current_level.filename + name] = delete

func load(game_data):
	if not Engine.is_editor_hint():
		if game_data.has(get_tree().current_scene.current_level.filename + name):
			if game_data.get(get_tree().current_scene.current_level.filename + name):
				queue_free()

func disappear():
	delete = true
	GameSaver.save()
	GameSaver.partial_save(self)
	queue_free()

func delete():
	queue_free()

func change_animation(new_animation):
	sprite_num = new_animation
	$Sprite.frame = sprite_num
