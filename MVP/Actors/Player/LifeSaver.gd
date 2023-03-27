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
extends Sprite

var player : Player
var rads := 0.0

onready var animation_player := $AnimationPlayer

func _ready():
	yield(get_tree().create_timer(0.2), "timeout")
	get_material().set("shader_param/flashState", 0.0)
	animation_player.play("Spawn")
	global_position.x = player.global_position.x
	global_position.y = player.global_position.y - 80

func _physics_process(delta):
	if is_instance_valid(player):
		global_position.x = lerp(global_position.x, player.global_position.x + (-15 if player.facing_right else 15), 0.1)
		global_position.y -= 3 * sin(rads)
		global_position.y = lerp(global_position.y, player.global_position.y - 65, 0.05)
		global_position.y += 3 * sin(rads)
		rads += delta * 4.5
