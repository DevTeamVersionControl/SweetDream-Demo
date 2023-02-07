# Sweet Dream, a sweet metroidvannia
#    Copyright (C) 2022 Kamran Charles Nayebi and William Duplain
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
extends Node2D

signal level_loaded

const PLAYER = preload("res://Actors/Player/Player.tscn")

onready var gui = $GUI
onready var level_transition = gui.color_rect
onready var hud = $HUD
onready var shaker = $Shaker

export var first_level = preload("res://Levels/FirstLevel.tscn")

var current_level : Node2D
var next_level : PackedScene
var door_location : String
var player : Player
var checkpoint = GlobalTypes.Checkpoint.new("Checkpoint",first_level)

func _ready():
	GlobalVars.initialize()
	load_level(checkpoint.level, checkpoint.name)

func save(game_data):
	game_data["checkpoint_level"] = checkpoint.level.resource_path
	game_data["checkpoint_name"] = checkpoint.name

func load(game_data):
	checkpoint = GlobalTypes.Checkpoint.new(game_data["checkpoint_name"],load(game_data["checkpoint_level"]))

func change_level(new_level:PackedScene, portal_name:String):
	var tween = get_tree().create_tween()
	tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(level_transition, "self_modulate", Color(0, 0, 0, 1), 1)
	tween.tween_callback(self, "_on_animation_finished")
	gui.request_pause()
	next_level = new_level
	door_location = portal_name

func _on_animation_finished():
	if next_level != null:
		load_level(next_level, door_location)
		gui.request_unpause()

func load_level(level:PackedScene, location:String):
	if current_level != null:
		current_level.queue_free()
	current_level = level.instance()
	add_child(current_level)
	player = PLAYER.instance()
	player.level_limit_min = Vector2(current_level.level_range_x.x, current_level.level_range_y.x)
	player.level_limit_max = Vector2(current_level.level_range_x.y, current_level.level_range_y.y)
	current_level.add_child(player)
	hud.connect_player()
	if location != "":
		var door_node = current_level.find_node(location)
		if door_node:
			player.camera.smoothing_enabled = false
			player.global_position = door_node.get_spawn_position()
			player.update()
	player.level_limit_min = Vector2(current_level.level_range_x.x, current_level.level_range_y.x)
	player.level_limit_max = Vector2(current_level.level_range_x.y, current_level.level_range_y.y)
	shaker.camera = player.camera
	var tween = get_tree().create_tween()
	tween.tween_property(level_transition, "self_modulate", Color(0, 0, 0, 0), 1)
	next_level = null
	emit_signal("level_loaded")

func die():
	next_level = checkpoint.level
	GlobalVars.health_packs = GlobalVars.max_health_packs
	GlobalVars.health = GlobalVars.max_health
	GlobalVars.sugar = GlobalVars.max_sugar
	call_deferred("load_level", next_level, checkpoint.name)

func set_checkpoint(new_checkpoint):
	checkpoint = new_checkpoint

func checkpoint_on(checkpoint_name) -> bool:
	return (checkpoint.name == checkpoint_name) && (load(current_level.filename) == checkpoint.level)

func start_dialog(dialog_file:String):
	gui.dialog.start(dialog_file)
	gui.request_pause()

func start_shop(shop_file:String):
	gui.shop.start(shop_file)
	gui.request_pause()
