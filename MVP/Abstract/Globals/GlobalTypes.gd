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

class Checkpoint:
	var name:String
	var level:PackedScene
	func _init(init_name, init_level):
		name = init_name
		level = init_level
