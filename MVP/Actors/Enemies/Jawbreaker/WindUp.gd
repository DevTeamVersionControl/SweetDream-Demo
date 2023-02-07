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

#Handles winding up
const DASH_SPEED = 500

var stunned := false

func enter(_msg := {}) -> void:
	if jawbreaker.health > 0:
		jawbreaker.animation_player.play("WindUp" if jawbreaker.facing_right else "WindUpLeft")
	yield(jawbreaker.animation_player, "animation_finished")
	if state_machine.state.name == "WindUp" && !stunned:
		state_machine.transition_to("Charge")

func physics_update(_delta: float) -> void:
	jawbreaker.motion.y += jawbreaker.gravity
	jawbreaker.motion = jawbreaker.move_and_slide(jawbreaker.motion)

func charge():
	var tween = get_tree().create_tween()
	tween.tween_property(jawbreaker, "motion", Vector2(DASH_SPEED if jawbreaker.facing_right else -DASH_SPEED,0), 14.0/24.0)

func stun():
	stunned = true
	jawbreaker.motion.x = 0
	jawbreaker.animation_player.play("WindDown")
#	jawbreaker.animation_player.stop(false)
#	jawbreaker.animation_player.seek(0, true)
	yield(get_tree().create_timer(2.5), "timeout")
	state_machine.transition_to("Idle")
