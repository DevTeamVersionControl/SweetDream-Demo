extends Area2D

export var description = {"Name":"Quest Item", "Icon":"Item 3.png", "Price":"30","Unit":"artifacts", "Description":"It's that quest item another npc asked for to progress the main story"} 

func _ready():
	$Sprite.texture = ResourceLoader.load(description.get("Icon"))

func _on_Artifact_body_entered(body):
	if body is Player:
		GlobalVars.add_to_inventory(description)
		queue_free()
