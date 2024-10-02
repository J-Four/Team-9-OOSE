extends Node

@onready var Deckname 
@onready var PrevArrow : Button = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PrevArrow")
@onready var PrevArrowD : Button = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PrevArrowDisabled")
@onready var NextArrow : Button = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/NextArrow")
@onready var QLabel : Label = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/QLabel")
@onready var ATextEdit : TextEdit = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ATextEdit")
@onready var TimerBar : ProgressBar = get_node("PanelContainer/VBoxContainer/PanelContainer3/MarginContainer/ProgressBar")
@onready var Timerlabel : Label = get_node("PanelContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/TimerLabel")
@onready var answer_line_edit: LineEdit = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/AnswerLineEdit")
@onready var card_progress_hbox: HBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer5/MarginContainer/CardProgressHBoxContainer")
@onready var card_progress_label: Resource = preload("res://Scenes/CardProgressLabel.tscn")
@onready var black_heart_texture: Resource = preload("res://Assets/Images/BlackHeart.png")
@onready var lives: Array = [
	get_node("PanelContainer/VBoxContainer/PanelContainer4/MarginContainer/BoxContainer/CenterContainer/Heart1"),
	get_node("PanelContainer/VBoxContainer/PanelContainer4/MarginContainer/BoxContainer/CenterContainer2/Heart2"),
	get_node("PanelContainer/VBoxContainer/PanelContainer4/MarginContainer/BoxContainer/CenterContainer3/Heart3")
	]
	
var currentCard : int = 1
var numCards: int = 1
var currentDeck : Dictionary
var cards: Array
var current_card_idx: int = -1
var num_cards: int = 0
var lives_idx: int = 0
var progress_labels: Array # Array that holds all the progress labels that will be added to the top of the screen.
var count_down_timer: bool = true
var cards_correct: int = 0
var cards_wrong: int = 0
var game_over: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set lives index to the last index in the lives array.
	lives_idx = len(lives) - 1
	
	TimerBar.max_value = 60
	TimerBar.value = TimerBar.max_value
	currentDeck = Global.deck_data
	cards = currentDeck["Cards"].duplicate(true)
	num_cards = len(cards)
	
	# Add the card progress labels at top of screen.
	for i in range(num_cards):
		var prog_label: Label = card_progress_label.instantiate()
		prog_label.text = str(i + 1)
		card_progress_hbox.add_child(prog_label)
		progress_labels.append(prog_label)
	
	# If Random order property is set to true, shuffle the order of the cards in the cards array
	if "Random order" in currentDeck.keys():
		if currentDeck["Random order"]:
			cards.shuffle()
	else:
		MessageDisplayer.error_popup("Error getting 'Random order' property in deck.", self)
	
	current_card_idx = 0
	display_card(current_card_idx)
	#_open_deck(Global.ChosenDeck)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#TimerBar.value = TimerBar.value - 0.01
	#Timerlabel.text = str(roundf(TimerBar.value))
	#if (TimerBar.value == 0):
		#Timerlabel.text = "Time's Up!"
		#await get_tree().create_timer(1).timeout
		#_on_next_arrow_pressed()

func _process(delta: float) -> void:
	if count_down_timer:
		TimerBar.value -= delta # Delta is the time in seconds between the current frame and the previous frame. If I remember correctly.
		Timerlabel.text = str(TimerBar.value)
		if (TimerBar.value <= 0):
			Timerlabel.text = "Time's Up!"
			await get_tree().create_timer(1).timeout
			_on_next_arrow_pressed()


func display_card(card_idx: int):
	QLabel.text = cards[card_idx]["Question"]
	answer_line_edit.text = ""


func _open_deck(Dname : String):
	
	var dir_path: String = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/flash_cards"
	var dir = DirAccess.open(dir_path) #grabbed a lot of this straight from Main menu script
	if not dir:
		MessageDisplayer.error_popup("Error reading desktop path.", self)
		return
	
	if (dir.file_exists(Dname + ".json")):
		print("Found: " + Dname)
		var deck_file = FileAccess.open(dir_path + "/" + Dname + ".json", FileAccess.READ)
		var data_str: String = deck_file.get_as_text()
		
		var json = JSON.new()
		var error = json.parse(data_str)
		
		if error == OK:
			var data: Dictionary = json.data
			_load_deck(Dname, data)
		else:
			MessageDisplayer.error_popup("JSON parse error: " + json.get_error_message() + " in " + data_str, self)
	else:
		QLabel.text = "deck not found"
		print("deck not found")

func _load_deck(Dname : String, data : Dictionary):
	PrevArrow.visible = false
	currentDeck = data
	numCards = len(data["Cards"]) #getting number of cards
	QLabel.text = str(data["Cards"][currentCard-1]["Question"]) #filling in question text
	
	pass

func _change_card_display(idx : int):
	if (idx == 0): # if first card turn off left arrow
		PrevArrow.visible = false
		PrevArrowD.visible = true
	else:
		PrevArrow.visible = true
		PrevArrowD.visible = false
	
	NextArrow.visible = true
	QLabel.text = str(currentDeck["Cards"][currentCard-1]["Question"]) #filling in question text
	ATextEdit.clear()

	
func _verify_answer() -> bool:
	var trueDict : Dictionary = {"Case sensitive":true}
	if (currentDeck["Cards"][currentCard-1]["Case sensitive"] == trueDict["Case sensitive"] ):
		if (str(currentDeck["Cards"][currentCard-1]["Answer"]).nocasecmp_to(ATextEdit.text) == 0):
			return true
		else: 
			return false
	else:
		if (str(currentDeck["Cards"][currentCard-1]["Answer"]).casecmp_to(ATextEdit.text) == 0):
			return true
		else:
			return false


func _on_next_arrow_pressed() -> void:
	_on_answer_line_edit_text_submitted(answer_line_edit.text)
	return
	
	if (_verify_answer()):
		if (currentCard == numCards):
			get_tree().change_scene_to_file("res://Scenes/DeckEnd.tscn")
		else: 
			currentCard = currentCard + 1
			_change_card_display(currentCard)
	else: 
			return
	
	

func _on_prev_arrow_pressed() -> void:
	if (currentCard != 1):
		currentCard = currentCard - 1
		_change_card_display(currentCard)
	


func _on_exit_button_pressed() -> void:
	SceneTransitioner.transition_in_from_top_bounce("res://Scenes/MainSceneControl.tscn")


func deck_complete(msg: String, wait_time: int = 1):
	game_over = true
	count_down_timer = false
	Timerlabel.text = msg
	
	Global.num_cards = num_cards
	Global.cards_correct = cards_correct
	Global.cards_wrong = cards_wrong
	Global.lives_left = lives_idx + 1
	
	await get_tree().create_timer(wait_time).timeout
	SceneTransitioner.transition_in_from_right_cubic("res://Scenes/DeckEnd.tscn")
	#get_tree().change_scene_to_file("res://Scenes/DeckEnd.tscn")


func _on_answer_line_edit_text_submitted(new_text: String) -> void:
	if game_over:
		return
	# String entered by user
	var user_str: String = new_text
	# Correct answer string
	var answer_str: String = cards[current_card_idx]["Answer"]
	
	# If not case sensitive, remove upper case.
	if not cards[current_card_idx]["Case sensitive"]:
		user_str = user_str.to_lower()
		answer_str = answer_str.to_lower()
	# If not space sensitive, remove spaces.
	if not cards[current_card_idx]["Space sensitive"]:
		user_str = user_str.replace(" ", "")
		answer_str = answer_str.replace(" ", "")
	
	# Check if user has correct answer
	if user_str == answer_str:
		# TODO: Some visual and audio effect for correct answer
		progress_labels[current_card_idx].modulate = Color.GREEN
		cards_correct += 1
		
		# If this is the final card, go to end screen. Else go to next card
		if current_card_idx == num_cards - 1:
			deck_complete("Deck Complete!", 2)
		else:
			current_card_idx += 1
			display_card(current_card_idx)
	else:
		# TODO: Some visual and audio effect for wrong answer
		progress_labels[current_card_idx].modulate = Color.RED
		cards_wrong += 1
		
		# If lives are left, subtract one life.
		if lives_idx >= 0:
			lives[lives_idx].texture = black_heart_texture
			var tween = get_tree().create_tween()
			tween.tween_property(lives[lives_idx], "custom_minimum_size", Vector2(0, 0), 0.25)
			tween.tween_callback(lives[lives_idx].hide)
			#lives[lives_idx].hide()
			lives_idx -= 1
		
		# If there are no more lives left, lose the game
		if lives_idx < 0:
			Global.lost = true
			deck_complete("Out of lives!", 2)
			return
			# TODO: Lose game here
		
		# If this is the final card, go to end screen. Else go to next card
		if current_card_idx == num_cards - 1:
			deck_complete("Deck Complete!", 2)
		else:
			current_card_idx += 1
			display_card(current_card_idx)
