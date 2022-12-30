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
extends JawbreakerState

#Handles charging
const DASH_SPEED = 300
const DASH_TIME = 1

@onready var charge_length_timer := $ChargeLengthTimer

func enter(_msg := {}) -> void:
	print("jawbreaker transitionned to charge")
	jawbreaker.animation_player.play("Run")
	jawbreaker.motion.x = 0
	jawbreaker.motion.x = DASH_SPEED if jawbreaker.facing_right else -DASH_SPEED
	charge_length_timer.start(DASH_TIME)

func physics_update(_delta: float) -> void:
	jawbreaker.motion.y += jawbreaker.gravity
	jawbreaker.set_velocity(jawbreaker.motion)
	jawbreaker.move_and_slide()
	jawbreaker.motion = jawbreaker.velocity

func on_dash_end():
	if jawbreaker.get_node_or_null("StateMachine/Death") != null:
		state_machine.transition_to("WindDown")
