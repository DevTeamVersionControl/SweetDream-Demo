extends Control


func _unhandled_input(event):
	if event.is_action_pressed("show_menu"):
		if get_tree().paused:
			_on_Cancel_pressed()
		else:
			get_tree().paused = true
			visible = true

func _on_Exit_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _on_Cancel_pressed():
	get_tree().paused = false
	visible = false

func _on_Options_pressed():
	pass # Replace with function body.
