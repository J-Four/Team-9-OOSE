extends Node

@onready var popup: Resource = preload("res://Scenes/ErrorPopup.tscn")
var deck_save_directory: String = str(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)) + "/flash_cards"

var deck_data: Dictionary
var ChosenDeck : String
var deck_xp : int
var skips : int = 3
var num_cards: int = 0
var cards_correct: int = 0
var cards_wrong: int = 0
var lost: bool = false
var lives_left: int = 0
var deck_name: String = ""

#user var default
var spriteChosen: String = "MAdventurer"
var brainPower: int = 0
var unlockedSprites: Dictionary = {
			"MAdventurer": true,
			"FAdventurer": true,
			"MSkelly": false,
			"FSkelly": false,
			"Elf": false,
			"Princess": false
		}
var userUpdated: bool = false #trying to get around some timing logic of when to write user

var userAchievements: Dictionary = {
	"100_Correct": {"Achieved": false,"needed_to_complete": 100},
	"100_wrong": {"Achieved": false,"needed_to_complete": 100},
	"20_study_sessions": {"Achieved": false,"needed_to_complete": 20},
	"100_BP": {"Achieved": false,"needed_to_complete": 100},
	"first_buddy_unlocked": {"Achieved": false,"needed_to_complete": 1}
}


var greenTheme = Color("75ac73")
var orangeTheme = Color("ca8b5c")
var redTheme = Color("7c3346")
var originalTheme = Color("ffffff")
var grayedOut = Color("7f7f7f")

signal write_successful


func reset() -> void:
	num_cards = 0
	cards_correct = 0
	cards_wrong = 0
	lost = false
	lives_left = 0
	deck_name = ""


func add_and_save_xp_to_deck(xp: int):
	deck_data["XP"] += xp
	
	# Save deck as json file in folder.
	var json_string = JSON.stringify(deck_data)
	
	# Create folder if it does not already exist
	var dir = DirAccess.open(deck_save_directory)
	if dir:
		if not dir.dir_exists("flash_cards"):
			dir.make_dir("flash_cards")
	else:
		MessageDisplayer.error_popup("Error reading path: " + deck_save_directory, self)
		return
	
	# Check if file with deck name aleady exists
	var file_exists = FileAccess.open(deck_save_directory + "/" + deck_name + ".json", FileAccess.READ)
	if not file_exists:
		print("Cannot find deck with the name '" + deck_name + "'.")
		var p = popup.instantiate()
		add_child(p)
		p.error_label.text = "Cannot find deck with the name '" + deck_name + "'. Would you like to save this data to a new deck file with name '" + deck_name + "'?"
		p.yes_button.pressed.connect(write_deck.bind(json_string, deck_name, false))
		p.yes_button.pressed.connect(p.free_self)
		p.no_button.pressed.connect(p.free_self)
		p.cancel_button.pressed.connect(p.free_self)
		p.show()
	else:
		write_deck(json_string, deck_name, false)

#delete deck, so duplicates are not made when changing deck name in edit, plus for clean up
func delete_deck(d_name: String) -> void:
	var path: String = str(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/flash_cards/" + d_name + ".json")
	DirAccess.remove_absolute(path)

func write_deck(json_string: String, d_name: String, display_popup: bool = true) -> void:
	# Create or overrite json file
	
	var path: String = str(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/flash_cards/" + d_name + ".json")
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print("Error writing json file.")
		MessageDisplayer.error_popup("Error writing json file. Check deck name.")
		return
	file.store_line(json_string)
	file.close()
	
	if display_popup:
		MessageDisplayer.green_popup_and_change_scene("Successfully saved deck to:\n" + path)
	
	write_successful_emit()


func write_successful_emit():
	print("Deck write successful.")
	emit_signal("write_successful")


# This will return the level of the given xp.
func get_level_from_xp(xp: int) -> int:
	if xp < 25:
		return 1
	var level: int = int(floorf(sqrt(sqrt(xp) - 4) + 1))
	return level


# This will return the xp start value of a given level
func get_xp_from_level(lvl: int) -> int:
	if lvl <= 1:
		return 0
	var xp: int = pow(pow(lvl - 1, 2) + 4, 2)
	return xp


# This will return the xp value the passed level starts at and the xp value the next level starts at.
func get_level_xp_bounds(lvl: int) -> Array:
	var lower_bound: int = get_xp_from_level(lvl)
	var upper_bound: int = get_xp_from_level(lvl + 1)
	return [lower_bound, upper_bound]
	
func write_user(display_popup: bool = true) -> void:
	if (userUpdated):#wont do it one the first time this is called when first opening app, so to not override existing user file with newuser
		#should save user data so BP, achievements, and unlocked studdy buddies carry over on different sessions.
		var studyDashUser: Dictionary = {
			"chosenStudybuddy": spriteChosen,
			"brainPower": brainPower,
			"unlockedStudyB":{
				"MAdventurer": unlockedSprites["MAdventurer"],
				"FAdventurer": unlockedSprites["FAdventurer"],
				"MSkelly": unlockedSprites["MSkelly"],
				"FSkelly": unlockedSprites["FSkelly"],
				"Elf": unlockedSprites["Elf"],
				"Princess": unlockedSprites["Princess"]
				},
			"userAchievements":{
				"100_Correct": {"Achieved": userAchievements["100_Correct"]["Achieved"],"needed_to_complete": userAchievements["100_Correct"]["needed_to_complete"]},
				"100_wrong": {"Achieved": userAchievements["100_wrong"]["Achieved"],"needed_to_complete": userAchievements["100_wrong"]["needed_to_complete"]},
				"20_study_sessions": {"Achieved": userAchievements["20_study_sessions"]["Achieved"],"needed_to_complete": userAchievements["20_study_sessions"]["needed_to_complete"]},
				"100_BP": {"Achieved": userAchievements["100_BP"]["Achieved"],"needed_to_complete": userAchievements["100_BP"]["needed_to_complete"]},
				"first_buddy_unlocked": {"Achieved": userAchievements["first_buddy_unlocked"]["Achieved"],"needed_to_complete": userAchievements["first_buddy_unlocked"]["needed_to_complete"]}
				}
			}
		var jsonUserString = JSON.stringify(studyDashUser)
		# Create or overrite json file
		var path: String = str(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/flash_cards/" + "studyDashUser" + ".json")
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file == null:
			print("Error writing json file for user.")
			MessageDisplayer.error_popup("Error writing json file for user.")
			return
		file.store_line(jsonUserString)
		file.close()
	else:
		userUpdated = true
	

func update_achievements() -> void: #will check if an achievement has been completed and update bool value
	if (userAchievements["100_Correct"]["needed_to_complete"] <= 0):
		userAchievements["100_Correct"]["Achieved"] = true
	if (userAchievements["100_wrong"]["needed_to_complete"] <= 0):
		userAchievements["100_wrong"]["Achieved"] = true
	if (userAchievements["20_study_sessions"]["needed_to_complete"] <= 0):
		userAchievements["20_study_sessions"]["Achieved"] = true
	if (userAchievements["100_BP"]["needed_to_complete"] <= 0):
		userAchievements["100_BP"]["Achieved"] = true
