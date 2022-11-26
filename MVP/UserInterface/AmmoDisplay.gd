extends CanvasLayer

export var player_path : NodePath
onready var player = get_node_or_null(player_path)

func _ready():
	if player:
		player.connect("changed_ammo", self, "_on_changed_ammo")
	else:
		printerr("player not detected, please manually connect player")

func _on_changed_ammo(ammo):
	$RichTextLabel.text = ammo.name
