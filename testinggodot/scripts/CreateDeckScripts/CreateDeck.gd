extends Node

@onready var nav_label: Label = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/NavigationLabel")
@onready var question_line_edit: LineEdit = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/QuestionLineEdit")
@onready var answer_edit: TextEdit = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/AnswerEdit")
@onready var case_checkbox: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer2/CaseCheckBox")
@onready var space_checkbox: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer2/SpaceCheckBox")
@onready var popup: Resource = preload("res://Scenes/ErrorPopup.tscn")

# Dictionary is a struct with key : value. Each of the 'Cards' part of a deck dictionary is an array
# of dictionaries.
var empty_array: Array[Dictionary]
# This is saved cards array first, lvl, scaleDiff last
var new_deck: Dictionary = { 
	"Scale difficulty": true,
	"Random order": true,
	"XP": 0,
	"Cards": empty_array.duplicate(true) # Makes another array of Dict to save cards
}
var current_card: int = -1
var deck_name: String = "Default Deck Name"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nav_label.text = "0 / 0" # The label in the bottoms that shows num of cards
	add_new_card_to_deck() # Run this func


func add_new_card_to_deck() -> void:
	# Temp Dict var to hold empty card
	var tmp: Dictionary = { 
		"Question": "",
		"Answer": "",
		"Case sensitive": false,
		"Space sensitive": false
		}
	# Add the empty card to "cards" array
	new_deck["Cards"].append(tmp.duplicate(true)) 
	
	# Update length of cards
	current_card = len(new_deck["Cards"]) - 1
	# Function to change display to this new empty card
	update_display_to_card(current_card)


# Updating the label on the bottom
func update_nav_label() -> void:
	nav_label.text = str(current_card + 1) + " / " + str(len(new_deck["Cards"]))


# Using int index to change card displayed
func update_display_to_card(card_idx: int) -> void:
	# Loading in what is saved to "cards"
	question_line_edit.text = new_deck["Cards"][card_idx]["Question"] 
	answer_edit.text = new_deck["Cards"][card_idx]["Answer"]
	case_checkbox.set_pressed_no_signal(new_deck["Cards"][card_idx]["Case sensitive"])
	space_checkbox.set_pressed_no_signal(new_deck["Cards"][card_idx]["Space sensitive"])
	update_nav_label()


# Changes the current_card index to passed int and updates display.
func change_card(card_idx: int) -> void:
	current_card = card_idx
	update_display_to_card(current_card)


# Change the card displayed to the current index minus 1
func _on_nav_left_button_pressed() -> void:
	current_card -= 1
	current_card = clamp(current_card, 0, len(new_deck["Cards"]) - 1)
	update_display_to_card(current_card)


# Change the card displayed to the current index plus 1
func _on_nav_right_button_pressed() -> void:
	current_card += 1
	current_card = clamp(current_card, 0, len(new_deck["Cards"]) - 1)
	update_display_to_card(current_card)


# Add a new blank card and change to it
func _on_add_card_button_pressed() -> void:
	add_new_card_to_deck()


# Update the question in the deck data when the user changes text in the question line edit
func _on_question_line_edit_text_changed(new_text: String) -> void:
	new_deck["Cards"][current_card]["Question"] = new_text


# Update the answer in the deck data when the user changes text in the answer line edit
func _on_answer_edit_text_changed() -> void:
	new_deck["Cards"][current_card]["Answer"] = answer_edit.text


# Update 'Case sensitive' in the deck data when the user toggles the 'Case sensitive' button
func _on_case_check_box_toggled(toggled_on: bool) -> void:
	new_deck["Cards"][current_card]["Case sensitive"] = toggled_on


# Update 'Space sensitive' in the deck data when the user toggles the 'Space sensitive' button
func _on_space_check_box_toggled(toggled_on: bool) -> void:
	new_deck["Cards"][current_card]["Space sensitive"] = toggled_on


# Update 'Scale difficulty' in the deck data when the user toggles the 'Scale difficulty' button
func _on_scale_difficulty_check_box_toggled(toggled_on: bool) -> void:
	new_deck["Scale difficulty"] = toggled_on


# Save the deck data to a json file
func _on_finish_deck_button_pressed() -> void:
	# Save deck as json file in folder on desktop. For now at least
	var json = JSON.new()
	var json_string = json.stringify(new_deck)
	
	# Create folder on desktop if it does not already exist
	var dir = DirAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP))
	if dir:
		if not dir.dir_exists("flash_cards"):
			dir.make_dir("flash_cards")
	else:
		MessageDisplayer.error_popup("Error reading desktop path.", self)
		# Return due to error.
		return
	
	# Check if file with deck name aleady exists
	print("name " + deck_name)
	var file_exists = FileAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/flash_cards/" + deck_name + ".json", FileAccess.READ)
	if file_exists:
		print("A deck with the name '" + deck_name + "' already exists.")
		# Create popup to inform the user
		var p = popup.instantiate()
		add_child(p)
		p.error_label.text = "A deck with the name '" + deck_name + "' already exists.\n Would you like to overwrite this deck?"
		p.yes_button.pressed.connect(Global.write_deck.bind(json_string, deck_name))
		p.yes_button.pressed.connect(p.free_self)
		p.no_button.pressed.connect(p.free_self)
		p.cancel_button.pressed.connect(p.free_self)
		p.show()
	else:
		Global.write_deck(json_string, deck_name)


# Update deck name when the user changes the deck name line edit
func _on_deck_name_line_edit_text_changed(new_text: String) -> void:
	# TODO: Probably need to do some validation on the deck name here so that the name can be used when saving the file
	deck_name = new_text


# Remove the currently selected/displayed card from the deck
func _on_remove_card_button_pressed() -> void:
	if len(new_deck["Cards"]) <= 1:
		return
	new_deck["Cards"].remove_at(current_card)
	# If last card was deleted go back one for display
	if current_card == (len(new_deck["Cards"])):
		_on_nav_left_button_pressed()
	else: 
		update_display_to_card(current_card)


# Update 'Random order' in the deck data when the user toggles the 'Random order' button
func _on_random_order_check_box_2_toggled(toggled_on: bool) -> void:
	new_deck["Random order"] = toggled_on


# Go back to the main menu after asking the user if they are sure with a popup
func _on_back_button_pressed() -> void:
	var p = popup.instantiate()
	add_child(p)
	p.error_label.text = "Are you sure you want to exit deck creation? Any unsaved changes will be lost."
	p.yes_button.pressed.connect(SceneTransitioner.transition_in_from_top_bounce.bind("res://Scenes/MainSceneControl.tscn"))
	p.yes_button.pressed.connect(p.free_self)
	p.no_button.pressed.connect(p.free_self)
	p.cancel_button.pressed.connect(p.free_self)
	p.show()
