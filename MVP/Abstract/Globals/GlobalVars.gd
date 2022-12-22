extends Node

const jello = preload("res://Ammo/Jello/Jello.tscn")
const candy_corn = preload("res://Ammo/Candy Corn/CandyCorn.tscn")
const jawbreaker = preload("res://Ammo/Jawbreaker/Jawbreaker.tscn")
const pop_rocks = preload("res://Ammo/Pop Rocks/PopRocks.tscn")
const jelly_bean = preload("res://Ammo/Jelly Bean/JellyBean.tscn")
const sticky_bomb = preload("res://Ammo/Sticky Bomb/StickyBomb.tscn")

var ammo_array := [GlobalTypes.Ammo.new("Candy Corn", GlobalTypes.AMMO_TYPE.once, 0.2, 1, candy_corn), GlobalTypes.Ammo.new("Jelly Bean", GlobalTypes.AMMO_TYPE.once, 2, 10, jelly_bean), GlobalTypes.Ammo.new("Jawbreaker", GlobalTypes.AMMO_TYPE.charge, 0, 3, jawbreaker), GlobalTypes.Ammo.new("Pop Rocks", GlobalTypes.AMMO_TYPE.constant, 0, 0.1, pop_rocks), GlobalTypes.Ammo.new("Jello", GlobalTypes.AMMO_TYPE.charge, 2, 3, jello), GlobalTypes.Ammo.new("Sticky Bomb", GlobalTypes.AMMO_TYPE.once, 1, 5, sticky_bomb)]
var door_name = null
var hp := 0
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
