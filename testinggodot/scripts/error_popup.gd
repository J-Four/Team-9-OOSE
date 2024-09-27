extends Panel

@onready var yes_button = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/YesButton")
@onready var no_button = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NoButton")
@onready var cancel_button = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CancelButton")
@onready var error_label = get_node("PanelContainer/MarginContainer/VBoxContainer/Label")
@onready var okay_button = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/OkayButton")


func free_self():
	queue_free()
