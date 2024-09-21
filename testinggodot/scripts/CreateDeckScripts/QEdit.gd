extends LineEdit

signal getQ()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_add_card_button_get_card(new_text: String) -> void:
	print(new_text)
	clear()
	pass # Replace with function body.
