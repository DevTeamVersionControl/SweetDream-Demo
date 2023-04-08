class_name CandyCornSpawner
extends KinematicBody2D

const DAMAGE = 5

var motion := Vector2.ZERO
var health := 15.0
var target : Player

onready var state_machine := $StateMachine
onready var animation_player := $AnimationPlayer
onready var candy_corn_spawn := $CandyCornSpawn
onready var player_detector := $PlayerDetector

func take_damage(damage:float, knockback:Vector2) -> void:
	health -= damage
	if state_machine.state.name == "Idle":
		on_something_detected(get_tree().current_scene.player)
	if health <= 0:
		state_machine.transition_to("Death")
	else:
		$Sprite.get_material().set("shader_param/flashState", 1.0)
		yield(get_tree().create_timer(0.1), "timeout")
		$Sprite.get_material().set("shader_param/flashState", 0.0)

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

func _on_something_leave(something):
	if something is Player && health > 0:
		target = null
		$StateMachine/Spawning/SpawnTimer.stop()
		state_machine.transition_to("Idle")
