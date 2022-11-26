extends Node

const jello = preload("res://Ammo/Jello/Jello.tscn")
const candy_corn = preload("res://Ammo/Candy Corn/CandyCorn.tscn")
const jawbreaker = preload("res://Ammo/Jawbreaker/Jawbreaker.tscn")
const pop_rocks = preload("res://Ammo/Pop Rocks/PopRocks.tscn")
const jelly_bean = preload("res://Ammo/Jelly Bean/JellyBean.tscn")
const sticky_bomb = preload("res://Ammo/Sticky Bomb/StickyBomb.tscn")

var ammo_array := [GlobalTypes.Ammo.new("Candy Corn", GlobalTypes.AMMO_TYPE.once, 1, candy_corn), GlobalTypes.Ammo.new("Jelly Bean", GlobalTypes.AMMO_TYPE.once, 2, jelly_bean), GlobalTypes.Ammo.new("Jawbreaker", GlobalTypes.AMMO_TYPE.charge, 5, jawbreaker), GlobalTypes.Ammo.new("Pop Rocks", GlobalTypes.AMMO_TYPE.constant, 0, pop_rocks), GlobalTypes.Ammo.new("Jello", GlobalTypes.AMMO_TYPE.charge, 2, jello), GlobalTypes.Ammo.new("Sticky Bomb", GlobalTypes.AMMO_TYPE.once, 1, sticky_bomb)]
var door_name = null
var hp := 0
var equiped_ammo = ammo_array[0]
var ammo_equipped_array := [get_ammo("Candy Corn"), get_ammo("Jelly Bean"), get_ammo("Sticky Bomb")]

func _ready():
	GameSaver.load()

func save(game_data):
	game_data.data["ammo_equipped_array"] = ammo_equipped_array
	game_data.data["equipped_ammo"] = equiped_ammo
	
func load(game_data):
	ammo_equipped_array = game_data.data["ammo_equipped_array"]
	equiped_ammo = game_data.data["equipped_ammo"]

func get_ammo(ammo_name : String):
	for ammo in ammo_array:
		if ammo.name == ammo_name:
			return ammo
	return null
