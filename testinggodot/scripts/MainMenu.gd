extends Node

@onready var deck_button: Resource = preload("res://Scenes/DeckButton.tscn")
@onready var hflow: HFlowContainer = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/PanelContainer/HFlowContainer")

var loaded_decks: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Open the directory that decks are saved at
	# TODO: change this from hard code to variable set by the user
	var dir_path: String = Global.deck_save_directory
	var dir = DirAccess.open(dir_path)
	if not dir:
		MessageDisplayer.error_popup("Error reading path: " + dir_path, self)
		return
	Global.write_user() #will update user changes only if not the first time this func is ran
	Global.update_achievements()
	# Get each json file in the direrctory
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if (not dir.current_is_dir()) and file_name.ends_with(".json"):
			if(file_name.begins_with("studyDashUser")): #the user file only
				print("Found user file: " + file_name)
				var userFile = FileAccess.open(dir_path + "/" + file_name, FileAccess.READ)
				var usrStr: String = userFile.get_as_text()
				
				var json = JSON.new()
				var error = json.parse(usrStr)
				if error == OK: #populate user data
					var studyDashUser: Dictionary = json.data
					Global.spriteChosen = studyDashUser["chosenStudybuddy"]
					Global.brainPower = studyDashUser["brainPower"]
					Global.unlockedSprites = studyDashUser["unlockedStudyB"]
					Global.userAchievements = studyDashUser["userAchievements"]
				else: # error handling
					MessageDisplayer.error_popup("JSON parse error: " + json.get_error_message() + "\nin file: " + file_name, self)
			else: # all other files in this dir should be desk.json files, this will populate the main menu
				print("Found: " + file_name)
				var deck_file = FileAccess.open(dir_path + "/" + file_name, FileAccess.READ)
				var data_str: String = deck_file.get_as_text()
				
				var json = JSON.new()
				var error = json.parse(data_str)
				if error == OK:
					var data: Dictionary = json.data
					add_deck_button(file_name.substr(0, file_name.rfind(".")), data) #using pre set deck button, use data to add button
				else:
					MessageDisplayer.error_popup("JSON parse error: " + json.get_error_message() + "\nin file: " + file_name, self)
		file_name = dir.get_next() #next file
	
	# reset global vars
	Global.ChosenDeck = ""
	Global.deck_name = ""
	Global.deck_data = {}
	


func add_deck_button(name: String, data: Dictionary):
	#add new button using deck name and data stored
	var new_deck = deck_button.instantiate()
	hflow.add_child(new_deck)
	new_deck.pressed.connect(_deck_pressed.bind(name)) #new button will run deck pressed func now
	new_deck.name = name
	new_deck.tooltip_text = name
	
	#set the theme for this deck using previously chosen theme, if deck is old version orignial theme is chosen
	if data.has("Theme"):
		match data["Theme"]:
			"Original":
				new_deck.self_modulate = Global.originalTheme
			"Green":
				new_deck.self_modulate = Global.greenTheme
			"Red":
				new_deck.self_modulate = Global.redTheme
			"Orange":
				new_deck.self_modulate = Global.orangeTheme
	else:
		new_deck.self_modulate = Global.originalTheme
	
	#usee XP saved in data to calculate lvl to display on button
	if "XP" in data.keys():
		var lvl = Global.get_level_from_xp(data["XP"])
		new_deck.text = name + "\nLvl " + str(lvl)
		loaded_decks[name] = data
		
		if lvl >= 5 and lvl < 10:
			new_deck.get_child(1).show()
		elif lvl >= 10 and lvl < 30:
			new_deck.get_child(1).show()
			new_deck.get_child(2).show()
			new_deck.get_child(4).show()
		elif lvl >= 30:
			new_deck.get_child(1).show()
			new_deck.get_child(2).show()
			new_deck.get_child(3).show()
			new_deck.get_child(4).show()
	else:
		new_deck.text = "Error"
		MessageDisplayer.error_popup("Error getting xp data from json file: " + name, self) # get_tree().root.get_child(1)
		new_deck.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/CreateDeck.tscn")

#selects the deck for either study or edit
func _deck_pressed(deck_name: String) -> void:
	Global.ChosenDeck = deck_name
	Global.deck_name = deck_name
	Global.deck_data = loaded_decks[deck_name]

#selected deck is used for study mode
func _study_pressed() -> void:
	if Global.deck_name != "":
		SceneTransitioner.transition_in_from_top_bounce("res://Scenes/playDeck.tscn")
	else:
		MessageDisplayer.error_popup("Please select the deck you want to study first.")

#selected deck is used for edit mode
func _on_edit_button_pressed() -> void:
	if Global.deck_name != "":
		SceneTransitioner.transition_in_from_right_cubic("res://Scenes/EditDeck.tscn")
	else:
		MessageDisplayer.error_popup("Please select the deck you want to edit first.")


func _on_create_deck_button_pressed() -> void:
	SceneTransitioner.transition_in_from_top_bounce("res://Scenes/CreateDeck.tscn")


func _on_edit_player_button_pressed() -> void:
	SceneTransitioner.transition_in_from_right_cubic("res://Scenes/PlayerCustomize.tscn")


func _on_view_achievements_button_pressed() -> void:
	SceneTransitioner.transition_in_from_right_cubic("res://Scenes/view_achievements.tscn")
