extends Node

@onready var popup: Resource = preload("res://Scenes/ErrorPopup.tscn")

var dismissed: bool = false

func display_message(msg: String):
	pass


func green_popup_and_change_scene(msg: String, node: Node = get_tree().root.get_child(get_tree().root.get_child_count() - 1), scn: String = "res://Scenes/MainSceneControl.tscn"):
	var p = popup.instantiate()
	node.add_child(p)
	
	p.error_label.modulate = Color.GREEN
	p.error_label.text = msg
	p.yes_button.hide()
	p.no_button.hide()
	p.cancel_button.hide()
	p.okay_button.show()
	p.okay_button.pressed.connect(SceneTransitioner.transition_in_from_right_cubic.bind(scn))
	p.show()


# Creates a popup with green text.
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




# Creates a popup with red text.
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
