extends Node

signal on
signal off

var on := true

export (NodePath) var trigger = ".."
onready var trigger_obj = get_node(trigger)

func _ready():
	if trigger_obj:
		trigger_obj.connect("on", self, "on_trigger_on")
		trigger_obj.connect("off", self, "on_trigger_off")

func on_trigger_on():
	on = false
	emit_signal("off")

func on_trigger_off():
	on = true
	emit_signal("on")
