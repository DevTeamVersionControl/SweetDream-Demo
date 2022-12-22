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

export var COOLDOWN = 2
export var CUBE_SPAWN_MIN_VOLUME = 0.4
const PIXELS_PER_METER = 16
const JELLO_CUBE = preload("res://Ammo/Jello/JelloCube.tscn")

export var launch_direction = Vector2(20,-10)
export var gravity := 9.8
var volume:= 0.0
var velocity = Vector2.ZERO


func _physics_process(delta):
	velocity.y += gravity/2 * pow(delta * 20, 2)
	velocity = move_and_slide(velocity*PIXELS_PER_METER)
	velocity /= PIXELS_PER_METER
	rotation = velocity.angle()
		
func launch(direction, strenght):
	velocity = launch_direction * strenght
	velocity.x *= direction.x
	grow(strenght)
	var scene = get_tree().current_scene
	var pos = global_position
	get_parent().crush_detection = false
	get_parent().get_node("CrushTimer").start(0.5)
	get_parent().remove_child(self)
	scene.add_child(self)
	global_position = pos + Vector2(0,-15)

func grow(add_volume):
	volume += add_volume/2
	set_deferred("scale", Vector2(volume,volume))

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		if body.is_in_group("jello"):
			body.grow(volume)
		else:
			body.take_damage(volume * velocity.length(), Vector2.ZERO)
		queue_free()
	elif body.is_in_group("floor"):
		#if velocity.y > 0:
			if volume > CUBE_SPAWN_MIN_VOLUME:
				var new_cube = JELLO_CUBE.instance()
				get_tree().current_scene.call_deferred("add_child", new_cube)
				new_cube.global_position = global_position
				new_cube.grow(volume)
			queue_free()
