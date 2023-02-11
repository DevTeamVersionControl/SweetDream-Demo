tool
extends Node2D

export var IDLE_DURATION = 2.0

var follow = Vector2.ZERO

export var move_to = Vector2.RIGHT * 192 setget set_move_to
export var speed = 2.0
export var trigger : NodePath
export var require_trigger = false

onready var trigger_obj = get_node_or_null(trigger)

func _ready():
	if Engine.is_editor_hint():
		set_physics_process(false)
	else :
		var duration = move_to.length() / float(speed * 96)
		$Tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, IDLE_DURATION)
		$Tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration + IDLE_DURATION * 2)
		$Tween.start()
		if !require_trigger:
			$Tween.resume_all()
		if trigger_obj && require_trigger:
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
	
func set_move_to(variable):
	move_to = variable
	update()

func _draw():
	if Engine.is_editor_hint():
		draw_line(Vector2.ZERO, move_to, Color(0.1, 0.0, 0.3), 3.0)
		draw_circle(move_to, 6.0, Color(0.1, 0.0, 0.3))
