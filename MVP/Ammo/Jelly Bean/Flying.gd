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
extends JellyBeanState

var bounces := 0
export var sticky := false

func enter(_msg := {}) -> void:
	jelly_bean.explosion_timer.start()
	jelly_bean.animation_player.play("Flying")

func physics_update(delta: float) -> void:
	jelly_bean.velocity.y += jelly_bean.GRAVITY * delta
	var collision = jelly_bean.move_and_collide(jelly_bean.velocity*delta, false)
	if collision != null && !sticky:
		_on_inpact(collision.normal)

func _on_inpact(normal):
	bounces += 1
	if bounces < 2:
		jelly_bean.velocity = jelly_bean.velocity.bounce(normal)
		jelly_bean.velocity *= 0.5
	else:
		jelly_bean.velocity = Vector2.ZERO

func _on_ExplosionTimer_timeout():
	state_machine.transition_to("Exploding")
