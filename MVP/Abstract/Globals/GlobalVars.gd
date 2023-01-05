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

const jello = preload("res://Ammo/Jello/Jello.tscn")
const candy_corn = preload("res://Ammo/Candy Corn/CandyCorn.tscn")
const jawbreaker = preload("res://Ammo/Jawbreaker/Jawbreaker.tscn")
const pop_rocks  = preload("res://Ammo/Pop Rocks/PopRocks.tscn")
const jelly_bean = preload("res://Ammo/Jelly Bean/JellyBean.tscn")
const BASE_MAX_HEALTH = 40.0
const BASE_MAX_SUGAR = 15.0

var ammo_array := [GlobalTypes.Ammo.new("Candy Corn", GlobalTypes.AMMO_TYPE.once, 0.2, 1, 1, candy_corn), 
	GlobalTypes.Ammo.new("Jelly Bean", GlobalTypes.AMMO_TYPE.once, 2, 8, 7.5, jelly_bean), 
	GlobalTypes.Ammo.new("Jawbreaker", GlobalTypes.AMMO_TYPE.charge, 0, 3, 5, jawbreaker), 
	GlobalTypes.Ammo.new("Pop Rocks", GlobalTypes.AMMO_TYPE.constant, 0, 0.1, 0.1, pop_rocks), 
	GlobalTypes.Ammo.new("Jello", GlobalTypes.AMMO_TYPE.once, 1, 2, 2, jello)]
var max_health := BASE_MAX_HEALTH
var health := max_health
var max_health_packs := 3
var health_packs := max_health_packs
var max_sugar := BASE_MAX_SUGAR
var sugar := max_sugar
var equiped_ammo_index = 0
var ammo_equipped_array := [get_ammo("Candy Corn"), get_ammo("Jelly Bean"), get_ammo("Jawbreaker"), get_ammo("Jello")]
var double_jump_lock := false
var dash_lock := false
var inventory := []
var artifacts := 30

func _ready():
	GameSaver.load()
	call_deferred("apply_items")

func save(game_data):
	var ammo_equipped_names := []
	for i in ammo_equipped_array.size():
		ammo_equipped_names.append(ammo_equipped_array[i].name)
	game_data.data["ammo_equipped_names"] = ammo_equipped_names
	game_data.data["equipped_ammo_index"] = equiped_ammo_index
	game_data.data["double_jump_lock"] = double_jump_lock
	game_data.data["dash_lock"] = dash_lock
	game_data.data["inventory"] = inventory
	game_data.data["artifacts"] = artifacts
	
func load(game_data):
	ammo_equipped_array = []
	for i in game_data.data["ammo_equipped_names"].size():
		ammo_equipped_array.append(get_ammo(game_data.data["ammo_equipped_names"][i]))
	equiped_ammo_index = game_data.data["equipped_ammo_index"]
	double_jump_lock = game_data.data["double_jump_lock"]
	dash_lock = game_data.data["dash_lock"]
	inventory = game_data.data["inventory"]
	artifacts = game_data.data["artifacts"]

func get_ammo(ammo_name : String):
	for ammo in ammo_array:
		if ammo.name == ammo_name:
			return ammo
	return null

func add_to_inventory(item:Dictionary):
	inventory.append(item)
	apply_items()

func add_max_health(num:int)->void:
	max_health += num
	health = max_health
	get_tree().current_scene.player.update_display()

func add_max_sugar(num:int)->void:
	max_sugar += num
	sugar = max_sugar
	get_tree().current_scene.player.update_display()

func apply_items():
	max_health = BASE_MAX_HEALTH
	max_sugar = BASE_MAX_SUGAR
	for item in inventory:
		if item.has("Effect"):
			call_deferred(item["Effect"][0], item["Effect"][1])
