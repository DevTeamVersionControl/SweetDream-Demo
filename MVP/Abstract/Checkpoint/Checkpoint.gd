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

const CHECKPOINT = preload("res://Abstract/Checkpoint/Checkpoint.wav")

onready var animation_player = $AnimationPlayer

var player_is_in_zone := false

func _ready():
	if get_tree().current_scene.checkpoint_on(name):
		animation_player.play("Opened")
	else:
		animation_player.play("Closed")

func _on_Checkpoint_body_entered(body):
	if body is Player:
		player_is_in_zone = true

func _on_Checkpoint_body_exited(body):
	if body is Player:
		player_is_in_zone = false

func _unhandled_key_input(_event):
	if player_is_in_zone && Input.is_action_just_pressed("interact") && not get_tree().current_scene.gui.pause_menu.visible:
		if get_tree().current_scene.checkpoint_on(name):
			GameSaver.save()
			get_tree().current_scene.die()
			get_tree().current_scene.start_rest_menu()
			GlobalVars.play_sound(CHECKPOINT)
		else:
			get_tree().current_scene.set_checkpoint(GlobalTypes.Checkpoint.new(name, load(get_tree().current_scene.current_level.filename)))
			animation_player.play("Opening")
			yield(animation_player, "animation_finished")
			animation_player.play("Opened")
			GameSaver.save()

func get_spawn_position() -> Vector2:
	return global_position
