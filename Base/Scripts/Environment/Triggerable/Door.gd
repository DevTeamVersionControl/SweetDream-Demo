extends StaticBody2D

export var trigger : NodePath
onready var trigger_obj = get_node(trigger)

func _ready():
	if trigger_obj:
		trigger_obj.connect("on", self, "on_trigger_on")
		trigger_obj.connect("off", self, "on_trigger_off")

func on_trigger_on():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.visible = false

func on_trigger_off():
	$CollisionShape2D.set_deferred("disabled", false)
	$Sprite.visible = true
