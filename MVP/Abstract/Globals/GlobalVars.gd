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
const pop_rocks = preload("res://Ammo/Pop Rocks/PopRocks.tscn")
const jelly_bean = preload("res://Ammo/Jelly Bean/JellyBean.tscn")
const sticky_bomb = preload("res://Ammo/Sticky Bomb/StickyBomb.tscn")

var ammo_array := [GlobalTypes.Ammo.new("Candy Corn", GlobalTypes.AMMO_TYPE.once, 0.2, 1, candy_corn), GlobalTypes.Ammo.new("Jelly Bean", GlobalTypes.AMMO_TYPE.once, 2, 8, jelly_bean), GlobalTypes.Ammo.new("Jawbreaker", GlobalTypes.AMMO_TYPE.charge, 0, 3, jawbreaker), GlobalTypes.Ammo.new("Pop Rocks", GlobalTypes.AMMO_TYPE.constant, 0, 0.1, pop_rocks), GlobalTypes.Ammo.new("Jello", GlobalTypes.AMMO_TYPE.charge, 2, 3, jello), GlobalTypes.Ammo.new("Sticky Bomb", GlobalTypes.AMMO_TYPE.once, 1, 5, sticky_bomb)]
var max_health := 40.0
var health := max_health
var max_health_packs := 3
var health_packs := max_health_packs
var equiped_ammo_index = 0
var ammo_equipped_array := [get_ammo("Candy Corn"), get_ammo("Jelly Bean"), get_ammo("Jawbreaker")]
var double_jump_lock := false
var dash_lock := false

func _ready():
	GameSaver.load()

func save(game_data):
	game_data.data["ammo_equipped_array"] = ammo_equipped_array
	game_data.data["equipped_ammo_index"] = equiped_ammo_index
	game_data.data["double_jump_lock"] = double_jump_lock
	game_data.data["dash_lock"] = dash_lock
	
func load(game_data):
	ammo_equipped_array = game_data.data["ammo_equipped_array"]
	equiped_ammo_index = game_data.data["equipped_ammo_index"]
	double_jump_lock = game_data.data["double_jump_lock"]
	dash_lock = game_data.data["dash_lock"]

func get_ammo(ammo_name : String):
	for ammo in ammo_array:
		if ammo.name == ammo_name:
			return ammo
	return null
