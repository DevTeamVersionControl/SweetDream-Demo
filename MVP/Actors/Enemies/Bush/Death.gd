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
extends BushState

const PICKUP = preload("res://Pickups/Pickup.tscn")

func enter(_msg := {}) -> void:
	
	bush.get_node("PhysicsBox").set_deferred("disabled", true)
	if bush.facing_left:
		bush.animation_player.play("DeathLeft")
	else:
		bush.animation_player.play("DeathRight")
	
	# Keeping this just in case I want to make it random again
	if randi()%1 == 0:
		var pickup := PICKUP.instance()
		pickup.disappear = true
		get_tree().current_scene.add_child(pickup)
		pickup.global_position = bush.global_position
		pickup.scale = Vector2(0.6,0.6)
		if randi()%4 != 0:
			pickup.description = {"Drop":"Sugar"}
			pickup.call_deferred("change_animation", 3)
		else:
			pickup.description = {"Drop":"Health"}
			pickup.call_deferred("change_animation", 1) 
