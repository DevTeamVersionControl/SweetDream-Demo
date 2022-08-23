extends KinematicBody2D

const PROJECTILE = preload("res://Scenes/NPCs/Enemies/JawbreakerBossProjectile.tscn")
const EXPLODED_SHELL = preload("res://Scenes/NPCs/Enemies/ExplodedShell.tscn")
const PICKUP = preload("res://Scenes/Environment/Pickups/AmmoPickup.tscn")

signal died
signal activate_pillar
signal pillar_shake

export var hp = 50
export var trigger : NodePath
onready var trigger_obj = get_node(trigger)
var invulnerable := false
var motion = Vector2.ZERO
var explosion_offset = 50
onready var screen_size = get_viewport_rect().size

func _ready():
	trigger_obj.connect("on", self, "on_trigger_on")
	$AnimationTree["parameters/conditions/active"] = false
	$AnimationTree["parameters/conditions/death"] = false
	$AnimationTree["parameters/conditions/phase3"] = false
	$CollisionShape2D.disabled = true

func wake_up():
	emit_signal("activate_pillar")
	$CollisionShape2D.disabled = false

func take_damage(damage, knockback):
	if invulnerable:
		return
	hp -= damage
	if hp <= 0:
		call_deferred("set_collision_layer_bit", 3, false)
		$AnimationTree["parameters/conditions/death"] = true
	elif hp <= 20:
		$AnimationTree["parameters/conditions/phase3"] = true

func face_right():
	motion = Vector2.RIGHT
	
func face_left():
	motion = Vector2.LEFT

func shoot_left():
	var projectile = PROJECTILE.instance()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position + Vector2(-90, 50)
	projectile.launch(true)
	
func shoot_right():
	var projectile = PROJECTILE.instance()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position + Vector2(90, 50)
	projectile.launch(false)
	
func explode():
	for i in 11:
		var exploded_shell = EXPLODED_SHELL.instance()
		exploded_shell.global_position = Vector2(screen_size.x/11 * i + explosion_offset, screen_size.y/6)
		get_tree().current_scene.add_child(exploded_shell)
		exploded_shell.activate(rand_range(0,0.5))
		if randi()%2 == 0:
			exploded_shell.transform.x *= -1
	explosion_offset = 300 if explosion_offset == 50 else 50
	
func die():
	var pickup = PICKUP.instance()
	pickup.global_position = global_position
	get_tree().current_scene.add_child(pickup)
	pickup.set_ammo(GlobalVars.ammo_type.jawbreaker)
	emit_signal("died")

func on_trigger_on():
	$AnimationTree["parameters/conditions/active"] = true

func _on_Area2D_body_entered(body):
	if body.is_in_group("destructable"):
		body.disappear()
