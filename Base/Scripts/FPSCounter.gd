extends CanvasLayer

func _process(delta):
	$Label.set_text("FPS : " + String(int(1/delta)))

