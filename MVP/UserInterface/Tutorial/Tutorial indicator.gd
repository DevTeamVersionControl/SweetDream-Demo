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
extends Area2D

onready var sprite := get_node_or_null("Sprite")

var save_path = GameSaver.save_path
var tween : SceneTreeTween
var seen := false

export var temporary = true

func _ready(): 
	sprite.visible = false

func _on_Tutorial_indicator_body_entered(body):
	if body is Player:
		sprite.visible = true
		tween = get_tree().create_tween()
		tween.tween_property(sprite, "position", Vector2(0,3), 0.6)
		tween.tween_property(sprite, "position", Vector2(0,-3), 0.6)
		tween.set_loops()
		seen = true

func _on_Tutorial_indicator_body_exited(body):
	if body is Player:
		sprite.visible = false
		tween.stop()

func save(game_data):
	game_data[get_tree().current_scene.current_level.filename + name] = seen if temporary else false

func load(game_data):
	if game_data.has(get_tree().current_scene.current_level.filename + name):
		if game_data.get(get_tree().current_scene.current_level.filename + name):
			queue_free()

func _exit_tree():
	GameSaver.save()
	GameSaver.partial_save(self)
