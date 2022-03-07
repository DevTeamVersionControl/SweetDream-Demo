extends CanvasLayer

export var trigger : NodePath

onready var trigger_obj = get_node(trigger)

func _ready():
	if trigger_obj:
		trigger_obj.connect("update", self, "on_update")

func on_update(vari):
	$Label.set_text(String(vari))
