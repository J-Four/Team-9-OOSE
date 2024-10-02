extends Node

@onready var deck_button: Resource = preload("res://Scenes/DeckButton.tscn")
@onready var hflow: HFlowContainer = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HFlowContainer")

var loaded_decks: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Probably should not load all decks everytime the main menu is loaded. Especially if we end up adding support for images in the future. Maybe add a reload or refresh button under 'file'.
	# Open the directory that decks are saved at
	# TODO: change this from hard code to variable set by the user
	var dir_path: String = Global.deck_save_directory
	var dir = DirAccess.open(dir_path)
	if not dir:
		MessageDisplayer.error_popup("Error reading path: " + dir_path, self)
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
				MessageDisplayer.error_popup("JSON parse error: " + json.get_error_message() + "\nin file: " + file_name, self)
		file_name = dir.get_next()


func add_deck_button(name: String, data: Dictionary):
	var new_deck = deck_button.instantiate()
	hflow.add_child(new_deck)
	new_deck.pressed.connect(_deck_pressed.bind(name)) #new button will run deck pressed func now
	new_deck.name = name
	new_deck.tooltip_text = name
	if "XP" in data.keys():
		new_deck.text = name + "\nLvl " + str(Global.get_level_from_xp(data["XP"]))
		loaded_decks[name] = data
	else:
		new_deck.text = "Error"
		MessageDisplayer.error_popup("Error getting xp data from json file: " + name, self) # get_tree().root.get_child(1)
		new_deck.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/CreateDeck.tscn")


func _deck_pressed(deck_name: String):
	Global.ChosenDeck = deck_name
	Global.deck_name = deck_name
	Global.deck_data = loaded_decks[deck_name]
	SceneTransitioner.transition_in_from_top_bounce("res://Scenes/playDeck.tscn")


func _on_edit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/EditDecks.tscn")


func _on_create_deck_button_pressed() -> void:
	SceneTransitioner.transition_in_from_top_bounce("res://Scenes/CreateDeck.tscn")
