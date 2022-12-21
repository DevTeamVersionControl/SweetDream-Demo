class_name CandyBush
extends KinematicBody2D

const DAMAGE = 20
const PULL_STRENGTH = 500

var hp = 20
var target
var facing_left := true

onready var animation_player := $AnimationPlayer
onready var state_machine := $StateMachine

# It's a bush it won't move
func knockback(_vector:Vector2):
	pass

func take_damage(damage:int, _vector:Vector2):
	hp -= damage
	if hp <= 0:
		state_machine.transition_to("Death")
