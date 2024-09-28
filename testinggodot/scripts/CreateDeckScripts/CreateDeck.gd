extends Node

@onready var nav_label: Label = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/NavigationLabel")
@onready var question_line_edit: LineEdit = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/QuestionLineEdit")
@onready var answer_edit: TextEdit = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer/AnswerEdit")
@onready var case_checkbox: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer2/CaseCheckBox")
@onready var space_checkbox: CheckBox = get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer2/HBoxContainer/VBoxContainer2/SpaceCheckBox")
@onready var popup: Resource = preload("res://Scenes/ErrorPopup.tscn")

var empty_array: Array[Dictionary] #dictionary is a struct with key : value
var new_deck: Dictionary = { #this is saved cards array first, lvl, scaleDiff last
	"Scale difficulty": true,
	"Level": 1,
	"Cards": empty_array.duplicate(true) #makes another array of Dict to save cards
}
var current_card: int = -1
var deck_name: String = "Default Deck Name"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nav_label.text = "0 / 0" # the label in the bottoms that shows num of cards
	add_new_card_to_deck() #run this func


func add_new_card_to_deck() -> void:
	var tmp: Dictionary = { #temp Dict var to hold empty card
		"Question": "",
		"Answer": "",
		"Case sensitive": false,
		"Space sensitive": false
		}
	new_deck["Cards"].append(tmp.duplicate(true)) #add the empty card to "cards" array
	
	current_card = len(new_deck["Cards"]) - 1 #update length of cards
	update_display_to_card(current_card) #function to change display to this new empty card


func update_nav_label() -> void: #updating the label on bottom
	nav_label.text = str(current_card + 1) + " / " + str(len(new_deck["Cards"]))


func update_display_to_card(card_idx: int) -> void: #using int to change display
	#loading in what is saved to "cards"
	question_line_edit.text = new_deck["Cards"][card_idx]["Question"] 
	answer_edit.text = new_deck["Cards"][card_idx]["Answer"]
	case_checkbox.set_pressed_no_signal(new_deck["Cards"][card_idx]["Case sensitive"])
	space_checkbox.set_pressed_no_signal(new_deck["Cards"][card_idx]["Space sensitive"])
	update_nav_label()


func change_card(card_idx: int) -> void:
	current_card = card_idx
	update_display_to_card(current_card)


func _on_add_card_button_get_card(_Card: Variant) -> void:
	pass # Replace with function body.


func _on_q_edit_text_set() -> void:
	pass # Replace with function body.


func _on_nav_left_button_pressed() -> void:
	current_card -= 1
	current_card = clamp(current_card, 0, len(new_deck["Cards"]) - 1)
	update_display_to_card(current_card)


func _on_nav_right_button_pressed() -> void:
	current_card += 1
	current_card = clamp(current_card, 0, len(new_deck["Cards"]) - 1)
	update_display_to_card(current_card)


func _on_add_card_button_pressed() -> void:
	add_new_card_to_deck()


func _on_question_line_edit_text_changed(new_text: String) -> void:
	new_deck["Cards"][current_card]["Question"] = new_text


func _on_answer_edit_text_changed() -> void:
	new_deck["Cards"][current_card]["Answer"] = answer_edit.text


func _on_case_check_box_toggled(toggled_on: bool) -> void:
	new_deck["Cards"][current_card]["Case sensitive"] = toggled_on


func _on_space_check_box_toggled(toggled_on: bool) -> void:
	new_deck["Cards"][current_card]["Space sensitive"] = toggled_on


func _on_scale_difficulty_check_box_toggled(toggled_on: bool) -> void:
	new_deck["Scale difficulty"] = toggled_on


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
		return
	
	# Check if file with deck name aleady exists
	var file_exists = FileAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/flash_cards/" + deck_name + ".json", FileAccess.READ)
	if file_exists:
		print("A deck with the name '" + deck_name + "' already exists.")
		var p = popup.instantiate()
		add_child(p)
		p.error_label.text = "A deck with the name '" + deck_name + "' already exists.\n Would you like to overwrite this deck?"
		p.yes_button.pressed.connect(write_deck.bind(json_string))
		p.yes_button.pressed.connect(p.free_self)
		p.no_button.pressed.connect(p.free_self)
		p.cancel_button.pressed.connect(p.free_self)
		p.show()
	else:
		write_deck(json_string)


func write_deck(json_string: String) -> void:
	# Create or overrite json file
	
	var path: String = str(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/flash_cards/" + deck_name + ".json")
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print("Error writing json file.")
		MessageDisplayer.error_popup("Error writing json file. Check deck name.", self)
		return
	file.store_line(json_string)
	file.close()
	
	MessageDisplayer.green_popup("Successfully saved deck to:\n" + path, self)


func _on_deck_name_line_edit_text_changed(new_text: String) -> void:
	# TODO: Probably need to do some validation on the deck name here so that the name can be used when saving the file
	deck_name = new_text


func _on_remove_card_button_pressed() -> void:
	if len(new_deck["Cards"]) <= 1:
		return
	new_deck["Cards"].remove_at(current_card)
	if current_card == (len(new_deck["Cards"])): #if last card was deleted go back one for display
		_on_nav_left_button_pressed()
	else: 
		update_display_to_card(current_card)
