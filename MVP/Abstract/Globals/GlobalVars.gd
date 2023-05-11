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
extends Node

const BASE_MAX_HEALTH = 40.0
const BASE_MAX_SUGAR = 15.0
const LIFESAVER = preload("res://Actors/Player/LifeSaver.tscn")

var ammo_array := [GlobalTypes.Ammo.new("Candy Corn", GlobalTypes.AMMO_TYPE.once, 0.15, 2, 1, preload("res://Ammo/Candy Corn/CandyCorn.tscn"), preload("res://Pickups/Candy Corn 720p.png")), 
	GlobalTypes.Ammo.new("Jelly Bean", GlobalTypes.AMMO_TYPE.once, 0.7, 6, 3, preload("res://Ammo/Jelly Bean/JellyBean.tscn"), preload("res://Pickups/Jelly Bean 720p.png")), 
	GlobalTypes.Ammo.new("Jawbreaker", GlobalTypes.AMMO_TYPE.charge, 0, 6, 5, preload("res://Ammo/Jawbreaker/Jawbreaker.tscn"), preload("res://Pickups/Jaw Breaker 720p.png")), 
	GlobalTypes.Ammo.new("Pop Rocks", GlobalTypes.AMMO_TYPE.constant, 0, 0.2, 0.1, preload("res://Ammo/Pop Rocks/PopRocks.tscn"), preload("res://Pickups/Jaw Breaker 720p.png")), 
	GlobalTypes.Ammo.new("Jello", GlobalTypes.AMMO_TYPE.once, 1, 10, 2, preload("res://Ammo/Jello/Jello.tscn"), preload("res://Pickups/Jello 720p.png"))]
var max_health := BASE_MAX_HEALTH
var health := max_health
var max_health_packs := 0
var health_packs := max_health_packs
var max_sugar := BASE_MAX_SUGAR
var sugar := max_sugar
var equiped_ammo_index = 0
var ammo_equipped_array := []
var double_jump_lock := false
var dash_lock := false
var map_lock := false
var inventory := []
var artifacts := 0

func initialize():
	ammo_equipped_array = []
	equiped_ammo_index = 0
	max_health = BASE_MAX_HEALTH
	max_health_packs = 0
	health = max_health
	health_packs = max_health_packs
	max_sugar = BASE_MAX_SUGAR
	sugar = max_sugar
	equiped_ammo_index = 0
	double_jump_lock = true
	dash_lock = true
	map_lock = true
	inventory = []
	artifacts = 0
	GameSaver.load()
	call_deferred("apply_items")

func save(game_data):
	var ammo_equipped_names := []
	for i in ammo_equipped_array.size():
		if ammo_equipped_array[i] != null:
			ammo_equipped_names.append(ammo_equipped_array[i].name)
		else:
			ammo_equipped_names.append(null)
	game_data["max_health_packs"] = max_health_packs
	game_data["ammo_equipped_names"] = ammo_equipped_names
	game_data["equipped_ammo_index"] = equiped_ammo_index
	game_data["double_jump_lock"] = double_jump_lock
	game_data["dash_lock"] = dash_lock
	game_data["map_lock"] = map_lock
	game_data["inventory"] = inventory
	game_data["artifacts"] = artifacts
	
func load(game_data):
	ammo_equipped_array = []
	for i in game_data["ammo_equipped_names"].size():
		if game_data["ammo_equipped_names"][i] != null:
			ammo_equipped_array.append(get_ammo(game_data["ammo_equipped_names"][i]))
		else:
			ammo_equipped_array.append(null)
	max_health_packs = game_data["max_health_packs"]
	equiped_ammo_index = int(game_data["equipped_ammo_index"])
	double_jump_lock = game_data["double_jump_lock"]
	dash_lock = game_data["dash_lock"]
	map_lock = game_data["map_lock"]
	inventory = game_data["inventory"]
	artifacts = game_data["artifacts"]

func get_ammo(ammo_name : String):
	for ammo in ammo_array:
		if ammo.name == ammo_name:
			return ammo
	return null

func add_to_inventory(item:Dictionary):
	inventory.append(item)
	apply_items()

func get_from_inventory(name:String):
	for item in inventory:
		if item.get("Name") and item["Name"] == name:
			return item
	return null
	
func remove_from_inventory(item_name:String):
	for i in inventory.size():
		if inventory[i].get("Name") == item_name:
			inventory.remove(i)

func add_max_health(num:int)->void:
	max_health += num
	health = max_health
	get_tree().current_scene.player.update_display()

func add_max_sugar(num:int)->void:
	max_sugar += num
	sugar = max_sugar
	get_tree().current_scene.player.update_display()

func add_currency(item:Dictionary):
	if item["Unit"] == "artifact":
		artifacts += item["Value"]

func apply_drop(item:Dictionary):
	if item["Drop"] == "Sugar":
		sugar += 10
		if sugar > max_sugar:
			sugar = max_sugar
	elif item["Drop"] == "Health":
		health += 15
		if health > max_health:
			health = max_health
	get_tree().current_scene.player.update_display()

func lifesaver(_placeholder)->void:
	if !is_instance_valid(get_tree().current_scene.player.lifesaver):
		var lifesaver = LIFESAVER.instance()
		get_tree().current_scene.current_level.add_child(lifesaver)
		lifesaver.player = get_tree().current_scene.player
		get_tree().current_scene.player.lifesaver = lifesaver

func unlock_map(_placeholder)->void:
	map_lock = false

func unlock_dash(_placeholder)->void:
	dash_lock = false
	
func unlock_double_jump(_placeholder)->void:
	double_jump_lock = false

func apply_items():
	max_health = BASE_MAX_HEALTH
	max_sugar = BASE_MAX_SUGAR
	for item in inventory:
		if item.has("Effect"):
			call_deferred(item["Effect"][0], item["Effect"][1])
		if item.has("Currency"):
			add_currency(item)
			inventory.erase(item)
		if item.has("Drop"):
			apply_drop(item)
			inventory.erase(item)

func play_sound(sound)->void:
	if $AudioStreamPlayer3.playing:
		if $AudioStreamPlayer2.playing:
			$AudioStreamPlayer.stream = sound
			$AudioStreamPlayer.play()
		else:
			$AudioStreamPlayer2.stream = sound
			$AudioStreamPlayer2.play()
	else:
		$AudioStreamPlayer3.stream = sound
		$AudioStreamPlayer3.play()
