extends StaticBody2D

export var trigger : NodePath
onready var trigger_obj = get_node(trigger)

func _ready():
	if trigger_obj:
		trigger_obj.connect("on", self, "on_trigger_on")

func on_trigger_on():
	call_deferred("set_collision_layer_bit", 0, false)
	call_deferred("set_collision_mask_bit", 0, false)
	$Sprite.visible = false
