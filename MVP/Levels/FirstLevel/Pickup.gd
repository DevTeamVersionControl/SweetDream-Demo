tool
extends Area2D

export var description = {
"Ammo": null,
"Description": "Basic but reliable ammo",
"Icon": "res://Pickups/Candy Corn 720p.png",
"Name": "Candy Corn",
"StoryPoint": [ "Gimald", 1 ],
"Temporary": null
}
export var sprite_num = 0 setget change_animation

var delete := false 
var save_path
var rads := 0.0

onready var sprite := $Sprite

func _ready():
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
	get_tree().current_scene.start_dialog("res://Levels/FirstLevel/Railroad.json", 0)
	GameSaver.save()
	GameSaver.partial_save(self)
	queue_free()

func _physics_process(delta):
	if not Engine.is_editor_hint():
		sprite.global_position.y -= 3 * sin(rads)
		rads += delta * 4.5
		sprite.global_position.y += 3 * sin(rads)

func change_animation(new_animation):
	sprite_num = new_animation
	$Sprite.frame = sprite_num
