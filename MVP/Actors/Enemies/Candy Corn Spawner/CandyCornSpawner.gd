class_name CandyCornSpawner
extends KinematicBody2D

const DAMAGE = 5

var motion := Vector2.ZERO
var health := 20.0
var target : Player

onready var state_machine := $StateMachine
onready var animation_player := $AnimationPlayer
onready var candy_corn_spawn := $CandyCornSpawn

func take_damage(damage:float, knockback:Vector2) -> void:
	health -= damage
	motion += knockback
	if health <= 0:
		state_machine.transition_to("Death")

func on_something_detected(something)->void:
	if something is Player && target == null:
		target = something
		state_machine.state.activate()

func on_hit_something(something)->void:
	if something is Player:
		something.take_damage(DAMAGE, Vector2.ZERO)

func _physics_process(_delta)->void:
	if health > 0:
		motion.y += 10
		motion.x = lerp(motion.x, 0, 0.1)
		motion = move_and_slide(motion)
