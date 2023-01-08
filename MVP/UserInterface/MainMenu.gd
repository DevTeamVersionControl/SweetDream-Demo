extends Control

onready var item_list = $ItemList
onready var input_menu = $InputMenu

func _ready():
	for i in range(0,item_list.get_item_count()):
		item_list.set_item_tooltip_enabled(i,false)
	item_list.select(0)
	item_list.grab_focus()

func _unhandled_input(event):
	if input_menu.visible:
		input_menu.input(event)
	else:
		item_list.grab_focus()
		if Input.is_action_pressed("ui_accept"):
			select_option()

func select_option():
	match item_list.get_item_text(item_list.get_selected_items()[0]):
		"Settings":
			input_menu.visible = true
		"Play":
			get_tree().change_scene("res://Abstract/LevelSwitcher.tscn")
		"Exit":
			get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
