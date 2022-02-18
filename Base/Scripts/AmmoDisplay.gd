extends CanvasLayer

const jello = preload("res://Assets/art/Animation/1080p_Ammo/1080p_Jello_Ammo/Jello_Ammo0001.png")
const candy_corn = preload("res://Assets/art/Animation/1080p_Ammo/1080p_Candy_Corn_Ammo/Candy_Corn_Ammo0001.png")
const icing_gun = preload("res://Scenes/Ammo/IcingGun.tscn")
const jawbreaker = preload("res://Assets/art/Animation/1080p_Ammo/1080p_Jaw_Breaker_Ammo/Ammo0001.png")
const popping_candy = preload("res://Assets/art/Animation/1080p_Ammo/1080p_Pop_Rocks_Ammo/Pop_Rocks_Ammo0004.png")
const jelly_bean = preload("res://Assets/art/Animation/1080p_Ammo/1080p_Jelly_Bean_Ammo/Jelly_Bean_Ammo0001.png")
const ammo = [candy_corn, jelly_bean, popping_candy, jawbreaker, jello]

export var player_path : NodePath
onready var player = get_node_or_null(player_path)

func _ready():
	if player:
		player.connect("changed_ammo", self, "_on_changed_ammo")
	else:
		printerr("player not detected, please manually connect player")

func _on_changed_ammo(ammo_index):
	$TextureRect.texture = ammo[ammo_index]
