extends Panel

func _ready():
	get_node("Button").connect("pressed", self, "_on_Button_Pressed")
	
func _on_Button_Pressed():
	get_node("Label").text = "HELLO!"
