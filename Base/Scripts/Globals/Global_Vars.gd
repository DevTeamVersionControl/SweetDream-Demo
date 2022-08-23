extends Node

const jello = preload("res://Scenes/Ammo/Jello.tscn")
const candy_corn = preload("res://Scenes/Ammo/CandyCorn.tscn")
const icing_gun = preload("res://Scenes/Ammo/IcingGun.tscn")
const jawbreaker = preload("res://Scenes/Ammo/Jawbreaker.tscn")
const popping_candy = preload("res://Scenes/Ammo/PoppingCandy.tscn")
const jelly_bean = preload("res://Scenes/Ammo/JellyBean.tscn")
const ammo_instance_array = [candy_corn, jelly_bean]

enum ammo_type {candy_corn, jelly_bean, popping_candy, jawbreaker, jello, icing_gun}
var door_name = null
var hp := 0
var equiped_ammo = ammo_type.candy_corn
var ammo_equipped_array = [candy_corn, jelly_bean]

func _ready():
	GameSaver.load()

func save(game_data):
	game_data.data["ammo_equipped_array"] = ammo_equipped_array
	
func load(game_data):
	ammo_equipped_array = game_data.data["ammo_equipped_array"]
