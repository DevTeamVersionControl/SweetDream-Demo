extends Node

signal on
signal off

var on := false

export (NodePath) var input_path1 = ".."
export (NodePath) var input_path2
onready var input_obj1 = get_node(input_path1)
onready var input_obj2 = get_node(input_path2)

func _ready():
	if input_obj1 && input_obj2:
		input_obj1.connect("on", self, "on_trigger_on1")
		input_obj1.connect("off", self, "on_trigger_off2")
		input_obj2.connect("on", self, "on_trigger_on1")
		input_obj2.connect("off", self, "on_trigger_off2")

func on_trigger_on1():
	on = true
	emit_signal("on")

func on_trigger_on2():
	on = true
	emit_signal("on")

func on_trigger_off1():
	if input_obj2.on:
		on = true
		emit_signal("on")
	else:
		emit_signal("off")
	
func on_trigger_off2():
	if input_obj1.on:
		on = true
		emit_signal("on")
	else:
		emit_signal("off")
