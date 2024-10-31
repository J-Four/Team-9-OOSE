extends Control

@onready var hairOpts: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/HairOpt")
@onready var eyesOpts: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/EyesOpt")
@onready var shirtOpts: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/ShirtOpt")
@onready var pantsOpts: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/PantsOpt")
@onready var shoesOpts: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/ShoesOpt")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cancel_pressed() -> void:
	# TODO: go to main menu w/o saving
	get_tree().change_scene_to_file("res://Scenes/MainSceneControl.tscn")


func _on_ok_pressed() -> void:
	# TODO: go to main menu and save
	get_tree().change_scene_to_file("res://Scenes/MainSceneControl.tscn")


func _on_hair_opts_pressed() -> void:
	hairOpts.set_visible(true) 
	eyesOpts.set_visible(false)
	shirtOpts.set_visible(false)
	pantsOpts.set_visible(false)
	shoesOpts.set_visible(false)


func _on_eyes_opt_pressed() -> void:
	hairOpts.set_visible(false) 
	eyesOpts.set_visible(true)
	shirtOpts.set_visible(false)
	pantsOpts.set_visible(false)
	shoesOpts.set_visible(false)


func _on_shirt_opts_pressed() -> void:
	hairOpts.set_visible(false) 
	eyesOpts.set_visible(false)
	shirtOpts.set_visible(true)
	pantsOpts.set_visible(false)
	shoesOpts.set_visible(false)


func _on_pants_opts_pressed() -> void:
	hairOpts.set_visible(false) 
	eyesOpts.set_visible(false)
	shirtOpts.set_visible(false)
	pantsOpts.set_visible(true)
	shoesOpts.set_visible(false)


func _on_shoes_opts_pressed() -> void:
	hairOpts.set_visible(false) 
	eyesOpts.set_visible(false)
	shirtOpts.set_visible(false)
	pantsOpts.set_visible(false)
	shoesOpts.set_visible(true)
