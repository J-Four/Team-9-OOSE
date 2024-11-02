extends Node

@onready var nav_label: Label = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/NavigationLabel")
@onready var question_line_edit: LineEdit = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/QuestionLineEdit")
@onready var answer_edit: TextEdit = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/AnswerEdit")
@onready var case_checkbox: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer2/CaseCheckBox")
@onready var space_checkbox: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer2/SpaceCheckBox")
@onready var popup: Resource = preload("res://Scenes/ErrorPopup.tscn")
@onready var answer_options: OptionButton = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer2/AnswerOption")
@onready var multiple_choice_format: VBoxContainer = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat")
@onready var answer_1: HBoxContainer = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer1")
@onready var answer_2: HBoxContainer = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer2")
@onready var answer_3: HBoxContainer = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer3")
@onready var answer_4: HBoxContainer = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer4")
@onready var tf_choice_format: VBoxContainer = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/TFAnswerFormat")
@onready var answer_true: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/TFAnswerFormat/TrueBox")
@onready var answer_false: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/TFAnswerFormat/FalseBox")
@onready var a1_checkbox: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer1/A1Checkbox")
@onready var a2_checkbox: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer2/A2Checkbox")
@onready var a3_checkbox: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer3/A3Checkbox")
@onready var a4_checkbox: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer4/A4Checkbox")
@onready var a1_line_edit: LineEdit = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer1/A1Edit")
@onready var a2_line_edit: LineEdit = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer2/A2Edit")
@onready var a3_line_edit: LineEdit = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer3/A3Edit")
@onready var a4_line_edit: LineEdit = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/MultiChoiceFormat/Answer4/A4Edit")



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
	add_answer_options() #fill option box for answer formats
	#update_answer_format()
	add_new_card_to_deck() # Run this func




func add_answer_options() -> void:
	answer_options.add_item("Free Response", 1)
	answer_options.add_item("Multiple Choice", 2)
	answer_options.add_item("T/F Choice", 3)

func add_new_card_to_deck() -> void:
	# Temp Dict var to hold empty card
	var tmp: Dictionary = { 
		"Question": "",
		"Answer": "",
		"Free Response": true,
		"T/F Choice": false,
		"Multiple Choice": false,
		"Case sensitive": false,
		"Space sensitive": false,
		"Multiple Answers": {
			"answer1": "",
			"answer2": "",
			"answer3": "",
			"answer4": ""
		} #a dictionary to hold multi answers
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
	if(new_deck["Cards"][card_idx]["Multiple Choice"]):
		_on_answer_option_item_selected(1)
		answer_options.selected = 1
		update_multiple_choice()
	if(new_deck["Cards"][card_idx]["Free Response"]):
		_on_answer_option_item_selected(0)
		answer_options.selected = 0
		answer_edit.text = new_deck["Cards"][card_idx]["Answer"]
	if(new_deck["Cards"][card_idx]["T/F Choice"]):
		_on_answer_option_item_selected(2)
		answer_options.selected = 2
	case_checkbox.set_pressed_no_signal(new_deck["Cards"][card_idx]["Case sensitive"])
	space_checkbox.set_pressed_no_signal(new_deck["Cards"][card_idx]["Space sensitive"])
	update_nav_label()

func update_multiple_choice() -> void:
	a1_line_edit.text = new_deck["Cards"][current_card]["Multiple Answers"]["answer1"]
	a2_line_edit.text = new_deck["Cards"][current_card]["Multiple Answers"]["answer2"]
	a3_line_edit.text = new_deck["Cards"][current_card]["Multiple Answers"]["answer3"]
	a4_line_edit.text = new_deck["Cards"][current_card]["Multiple Answers"]["answer4"]
	a1_checkbox.button_pressed = false
	a2_checkbox.button_pressed = false
	a3_checkbox.button_pressed = false
	a4_checkbox.button_pressed = false
	if(new_deck["Cards"][current_card]["Answer"] == "1"):
		a1_checkbox.button_pressed = true
	if(new_deck["Cards"][current_card]["Answer"] == "2"):
		a2_checkbox.button_pressed = true
	if(new_deck["Cards"][current_card]["Answer"] == "3"):
		a3_checkbox.button_pressed = true
	if(new_deck["Cards"][current_card]["Answer"] == "4"):
		a4_checkbox.button_pressed = true

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
	# var json = JSON.new() fixing a warning
	var json_string = JSON.stringify(new_deck)
	
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
		
	get_tree().change_scene_to_file("res://Scenes/MainSceneControl.tscn")


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


func _on_answer_option_item_selected(index: int) -> void:
	if(index == 0): #free responce becomes visible
		answer_edit.set_visible(true)
		multiple_choice_format.set_visible(false)
		tf_choice_format.set_visible(false)
		new_deck["Cards"][current_card]["Free Response"] = true
		new_deck["Cards"][current_card]["Multiple Choice"] = false
		new_deck["Cards"][current_card]["T/F Choice"] = false
	if(index == 1): #multi responce becomes visible
		answer_edit.set_visible(false)
		multiple_choice_format.set_visible(true)
		tf_choice_format.set_visible(false)
		new_deck["Cards"][current_card]["Free Response"] = false
		new_deck["Cards"][current_card]["Multiple Choice"] = true
		new_deck["Cards"][current_card]["T/F Choice"] = false
		update_multiple_choice()
	if(index == 2): #t/f responce becomes visible
		answer_edit.set_visible(false)
		multiple_choice_format.set_visible(false)
		tf_choice_format.set_visible(true)
		new_deck["Cards"][current_card]["Free Response"] = false
		new_deck["Cards"][current_card]["Multiple Choice"] = false
		new_deck["Cards"][current_card]["T/F Choice"] = true


func _on_true_box_toggled(toggled_on: bool) -> void:
	if (toggled_on): #if toggled on then other answer is not
		answer_false.button_pressed = false
		new_deck["Cards"][current_card]["Answer"] = "True" #assigning answer
	else:
		answer_false.button_pressed = true
		new_deck["Cards"][current_card]["Answer"] = "False"
	


func _on_false_box_toggled(toggled_on: bool) -> void:
	if (toggled_on): #if toggled on then other answer is not
		answer_true.button_pressed = false
		new_deck["Cards"][current_card]["Answer"] = "False" #assigning answer
	else:
		answer_true.button_pressed = true
		new_deck["Cards"][current_card]["Answer"] = "True"


func _on_a1_edit_text_changed(new_text: String) -> void:
	new_deck["Cards"][current_card]["Multiple Answers"]["answer1"] = new_text


func _on_a2_edit_text_changed(new_text: String) -> void:
	new_deck["Cards"][current_card]["Multiple Answers"]["answer2"] = new_text


func _on_a3_edit_text_changed(new_text: String) -> void:
	new_deck["Cards"][current_card]["Multiple Answers"]["answer3"] = new_text


func _on_a4_edit_text_changed(new_text: String) -> void:
	new_deck["Cards"][current_card]["Multiple Answers"]["answer4"] = new_text


func _on_a1_checkbox_toggled(toggled_on: bool) -> void:
	if (toggled_on): #if toggled on then other answers are not
		a2_checkbox.button_pressed = false
		a3_checkbox.button_pressed = false
		a4_checkbox.button_pressed = false
		new_deck["Cards"][current_card]["Answer"] = "1" #assigning answer


func _on_a2_checkbox_toggled(toggled_on: bool) -> void:
	if (toggled_on): #if toggled on then other answers are not
		a1_checkbox.button_pressed = false
		a3_checkbox.button_pressed = false
		a4_checkbox.button_pressed = false
		new_deck["Cards"][current_card]["Answer"] = "2" #assigning answer


func _on_a3_checkbox_toggled(toggled_on: bool) -> void:
	if (toggled_on): #if toggled on then other answers are not
		a1_checkbox.button_pressed = false
		a2_checkbox.button_pressed = false
		a4_checkbox.button_pressed = false
		new_deck["Cards"][current_card]["Answer"] = "3" #assigning answer


func _on_a4_checkbox_toggled(toggled_on: bool) -> void:
	if (toggled_on): #if toggled on then other answers are not
		a1_checkbox.button_pressed = false
		a2_checkbox.button_pressed = false
		a3_checkbox.button_pressed = false
		new_deck["Cards"][current_card]["Answer"] = "4" #assigning answer
