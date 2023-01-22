extends Control

onready var item_list = $ItemList
onready var input_menu = $InputMenu
onready var level_transition = $LevelTransition

var index := 0

func _ready():
	load_menu()
	for i in range(0,item_list.get_item_count()):
		item_list.set_item_tooltip_enabled(i,false)
	item_list.set_focus_mode(Control.FOCUS_NONE)
	item_list.select(index)

func _unhandled_input(event):
	if input_menu.visible:
		input_menu.input(event)
	else:
		if Input.is_action_pressed("ui_accept"):
			select_option()
		if Input.is_action_pressed("ui_back"):
			load_menu()
		if Input.is_action_pressed("ui_up"):
			index = clamp(index - 1, 0, item_list.get_item_count()-1)
			item_list.select(index)
		if Input.is_action_pressed("ui_down"):
			index = clamp(index + 1, 0, item_list.get_item_count()-1)
			item_list.select(index)
func select_option():
	if item_list.get_item_text(0) == "Play":
		match item_list.get_item_text(item_list.get_selected_items()[0]):
			"Settings":
				input_menu.visible = true
			"Play":
				load_saves()
			"Exit":
				get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
	else:
		var tween = get_tree().create_tween()
		GameSaver.save_path = "res://Saves/Save%s.json"%(item_list.get_selected_items()[0]+1)
		tween.tween_property(level_transition, "color", Color(0,0,0,1.2), 0.3)
		tween.tween_callback(get_tree(), "change_scene", ["res://Abstract/LevelSwitcher.tscn"])

func load_saves():
	item_list.clear()
	var file = File.new()
	for i in 3:
		if file.file_exists("res://Saves/Save%s.json"%(i+1)):
			item_list.add_item("Save" + String(i+1))
		else:
			item_list.add_item("New Game")
	index = 0
	item_list.select(index)

func load_menu():
	item_list.clear()
	item_list.add_item("Play")
	item_list.add_item("Settings")
	item_list.add_item("Exit")
	index = 0
	item_list.select(index)
