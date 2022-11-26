extends Node

#Defines enums visible for all objects
enum AMMO_TYPE{once, charge, constant}

class Ammo:
	var name : String
	var type : int
	var cooldown : float
	var scene : PackedScene
	func _init(name, type, cooldown, scene):
		self.name = name
		self.type = type
		self.cooldown = cooldown
		self.scene = scene
