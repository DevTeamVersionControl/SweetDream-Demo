tool
extends Area2D

const jello_png = preload("res://Assets/art/Animation/1080p_Ammo/1080p_Jello_Ammo/Jello_Ammo0001.png")
const candy_corn_png = preload("res://Assets/art/Animation/1080p_Ammo/1080p_Candy_Corn_Ammo/Candy_Corn_Ammo0001.png")
const jawbreaker_png = preload("res://Assets/art/Animation/1080p_Ammo/1080p_Jaw_Breaker_Ammo/Ammo0001.png")
const popping_candy_png = preload("res://Assets/art/Animation/1080p_Ammo/1080p_Pop_Rocks_Ammo/Pop_Rocks_Ammo0004.png")
const jelly_bean_png = preload("res://Assets/art/Animation/1080p_Ammo/1080p_Jelly_Bean_Ammo/Jelly_Bean_Ammo0001.png")
const ammo_png = [candy_corn_png, jelly_bean_png, popping_candy_png, jawbreaker_png, jello_png]
const jello = preload("res://Scenes/Ammo/Jello.tscn")
const candy_corn = preload("res://Scenes/Ammo/CandyCorn.tscn")
const icing_gun = preload("res://Scenes/Ammo/IcingGun.tscn")
const jawbreaker = preload("res://Scenes/Ammo/Jawbreaker.tscn")
const popping_candy = preload("res://Scenes/Ammo/PoppingCandy.tscn")
const jelly_bean = preload("res://Scenes/Ammo/JellyBean.tscn")
const ammo_instance = [candy_corn, jelly_bean, popping_candy, jawbreaker, jello]
enum ammo_type {candy_corn, jelly_bean, popping_candy, jawbreaker, jello}
export(ammo_type) var ammo setget set_ammo

func _ready():
	$Sprite.texture = ammo_png[ammo]

func set_ammo(new_ammo):
	ammo = new_ammo
	update()
	if Engine.is_editor_hint():
		$Sprite.texture = ammo_png[ammo]

func _on_AmmoPickup(body):
	if body.is_in_group("player"):
		queue_free()
		if GlobalVars.ammo_equipped_array.find(ammo_instance[ammo]) == -1:
			GlobalVars.ammo_equipped_array.append(ammo_instance[ammo])
			GameSaver.save()
			GameSaver.call_deferred("save_scene")
