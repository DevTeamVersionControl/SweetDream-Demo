extends Node

#Defines enums visible for all objects
enum AMMO_TYPE{once, charge, constant}

class Ammo:
	var name : String
	var type : int
	var cooldown : float
	var damage : float
	var scene : PackedScene
	func _init(ammo_name, ammo_type, ammo_cooldown, ammo_damage, ammo_scene):
		name = ammo_name
		type = ammo_type
		cooldown = ammo_cooldown
		damage = ammo_damage
		scene = ammo_scene
