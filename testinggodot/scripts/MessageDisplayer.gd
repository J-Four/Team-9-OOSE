extends Node

@onready var popup: Resource = preload("res://Scenes/ErrorPopup.tscn")


func display_message(msg: String):
	pass


func green_popup(msg: String, node: Node = get_tree().root.get_child(get_tree().root.get_child_count() - 1)):
	var p = popup.instantiate()
	node.add_child(p)
	
	p.error_label.modulate = Color.GREEN
	p.error_label.text = msg
	p.yes_button.hide()
	p.no_button.hide()
	p.cancel_button.hide()
	p.okay_button.show()
	p.okay_button.pressed.connect(p.free_self)
	p.show()


func error_popup(msg: String, node: Node = get_tree().root.get_child(get_tree().root.get_child_count() - 1)):
	var p = popup.instantiate()
	node.add_child(p)
	
	p.error_label.modulate = Color.RED
	p.error_label.text = "ERROR: " + msg
	p.yes_button.hide()
	p.no_button.hide()
	p.okay_button.show()
	p.okay_button.pressed.connect(p.free_self)
	p.cancel_button.pressed.connect(p.free_self)
	p.show()
