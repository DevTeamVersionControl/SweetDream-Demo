extends Node2D

export var IDLE_DURATION = 1.0

var follow = Vector2.ZERO

export var move_to = Vector2.RIGHT * 192
export var speed = 3.0
export var trigger : NodePath

onready var trigger_obj = get_node(trigger)

func _ready():
	var duration = move_to.length() / float(speed * 96)
	$Tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, IDLE_DURATION)
	$Tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration + IDLE_DURATION * 2)
	$Tween.start()
	if trigger_obj:
		trigger_obj.connect("on", self, "on_trigger_on")
		trigger_obj.connect("off", self, "on_trigger_off")
		if !trigger_obj.on:
			$Tween.stop_all()

func _physics_process(delta):
	$Platform.position = $Platform.position.linear_interpolate(follow, 0.075)

func on_trigger_on():
	$Tween.resume_all()

func on_trigger_off():
	$Tween.stop_all()
