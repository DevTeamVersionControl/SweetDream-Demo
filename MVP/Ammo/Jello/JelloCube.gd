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
extends KinematicBody2D

const PIXELS_PER_METER = 16

export var gravity := 9.8 * 8
export var volume = 0.5
var motion = Vector2.ZERO

func _physics_process(delta):
	motion.y += gravity * delta
	motion = move_and_slide(motion)

func grow(add_volume):
	volume += add_volume
	set_deferred("scale", Vector2(volume,volume))
	
func bounce():
	$AnimatedSprite.playing = true
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.playing = false
