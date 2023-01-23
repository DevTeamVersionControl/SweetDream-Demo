extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude := 0.0
var camera : Camera2D
var frequency : float
var done := false

func start(duration = 0.2, start_frequency = 15, start_amplitude = 16):
	camera = getCurrentCamera2D()
	$Timer.wait_time = duration
	self.frequency = start_frequency
	self.amplitude = start_amplitude
	done = false
	$Timer.start()
	new_shake()

func new_shake():
	var rand = Vector2.ZERO
	
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "offset", rand, 1/frequency)
	
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	tween.tween_property(camera, "offset", rand, 1/frequency)
	if !done:
		tween.tween_callback(self, "new_shake")
	else:
		tween.tween_property(camera, "offset", Vector2.ZERO, 1/frequency)

func _on_Timer_timeout():
	done = true

func getCurrentCamera2D():
	var viewport = get_viewport()
	if not viewport:
		return null
	var camerasGroupName = "__cameras_%d" % viewport.get_viewport_rid().get_id()
	var cameras = get_tree().get_nodes_in_group(camerasGroupName)
	for camera in cameras:
		if camera is Camera2D and camera.current:
			return camera
	return null
