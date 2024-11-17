extends Panel

@onready var yes_button = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/YesButton")
@onready var no_button = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NoButton")
@onready var cancel_button = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CancelButton")
@onready var error_label = get_node("PanelContainer/MarginContainer/VBoxContainer/Label")
@onready var okay_button = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/OkayButton")

var okay_pressed: bool = false

func free_self():
	queue_free()


func _on_okay_button_pressed() -> void:
	pass
	# Want to be able to use the popup without always going back to the main scene
	#get_tree().change_scene_to_file("res://Scenes/MainSceneControl.tscn")
