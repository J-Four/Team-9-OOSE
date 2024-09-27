extends Node

@onready var deck_button: Resource = preload("res://Scenes/DeckButton.tscn")
@onready var hflow: HFlowContainer = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HFlowContainer")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Open the directory that decks are saved at
	# TODO: change this from hard code to variable set by the user
	var dir_path: String = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/flash_cards"
	var dir = DirAccess.open(dir_path)
	if not dir:
		MessageDisplayer.error_popup("Error reading desktop path.", self)
		return
	
	# Get each json file in the direrctory
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if (not dir.current_is_dir()) and file_name.ends_with(".json"):
			print("Found: " + file_name)
			var deck_file = FileAccess.open(dir_path + "/" + file_name, FileAccess.READ)
			var data_str: String = deck_file.get_as_text()
			
			var json = JSON.new()
			var error = json.parse(data_str)
			if error == OK:
				var data: Dictionary = json.data
				add_deck_button(file_name.substr(0, file_name.rfind(".")), data)
			else:
				MessageDisplayer.error_popup("JSON parse error: " + json.get_error_message() + " in " + data_str, self)
		file_name = dir.get_next()


func add_deck_button(name: String, data: Dictionary):
	var new_deck = deck_button.instantiate()
	hflow.add_child(new_deck)
	if "Level" in data.keys():
		new_deck.text = name + "\nLvl " + str(data["Level"])
	else:
		new_deck.text = "Error"
		print(get_tree().root.get_child(1).name)
		MessageDisplayer.error_popup("Error getting level data from json file: " + name, get_tree().root.get_child(1))
		new_deck.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/CreateDeck.tscn")


func _on_deck_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_deck_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_deck_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_deck_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_deck_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_deck_6_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_edit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/EditDecks.tscn")


func _on_create_deck_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/CreateDeck.tscn")
