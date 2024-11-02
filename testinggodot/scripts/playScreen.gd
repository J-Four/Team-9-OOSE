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
@onready var correct_sfx: Resource = preload("res://Assets/Audio/Buff 001.wav")
@onready var wrong_sfx: Resource = preload("res://Assets/Audio/Debuff 001.wav")
@onready var lives: Array = [
	get_node("PanelContainer/VBoxContainer/PanelContainer4/MarginContainer/BoxContainer/CenterContainer/Heart1"),
	get_node("PanelContainer/VBoxContainer/PanelContainer4/MarginContainer/BoxContainer/CenterContainer2/Heart2"),
	get_node("PanelContainer/VBoxContainer/PanelContainer4/MarginContainer/BoxContainer/CenterContainer3/Heart3")
	]
@onready var TrueFalseChoice: HBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/TrueFalseChoice")
@onready var MultipleChoice: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/MultipleChoice")
@onready var a1_button: Button = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/MultipleChoice/HBoxContainer/A1Button")
@onready var a2_button: Button = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/MultipleChoice/HBoxContainer/A2Button")
@onready var a3_button: Button = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/MultipleChoice/HBoxContainer2/A3Button")
@onready var a4_button: Button = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/MultipleChoice/HBoxContainer2/A4Button")

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
	# So the index can be decreased by one at a time until it gets to 0
	lives_idx = len(lives) - 1
	
	# Set the timer value in seconds. This is hard coded right now but should be changed later to
	# differ depending on difficulty or level of deck.(TODO)
	TimerBar.max_value = 60
	TimerBar.value = TimerBar.max_value
	# Get the selected deck's data from the global 'Global' script.
	currentDeck = Global.deck_data
	# Pull out the array of cards into it's own seperate array.
	cards = currentDeck["Cards"].duplicate(true)
	# Get the number of cards in the deck.
	num_cards = len(cards)
	
	# Add the card progress labels at top of screen. One label per card. 
	# If the user gets the correct answer, the corresponding label for the card will turn green. 
	# If the user is wrong, it will be red.
	for i in range(num_cards):
		var prog_label: Label = card_progress_label.instantiate()
		prog_label.text = str(i + 1)
		card_progress_hbox.add_child(prog_label)
		# Put all of these labels into this array so they can be accessed later.
		progress_labels.append(prog_label)
	
	# If 'Random order' property of the deck data is set to true, 
	# shuffle the order of the cards in the cards array
	if "Random order" in currentDeck.keys():
		if currentDeck["Random order"]:
			cards.shuffle()
	else:
		MessageDisplayer.error_popup("Error getting 'Random order' property in deck.", self)
	
	# Set card index to the first card in the array to start with. 
	# This will be increased one at a time when the user enters an answer.
	current_card_idx = 0
	display_card(current_card_idx)


func _process(delta: float) -> void:
	# If 'count_down_timer' is true, decrease the timer by however much time has passed.
	if count_down_timer:
		# 'delta' is the time in seconds between the cirrent frame and the previous frame so we can
		# track how much time has passed.
		TimerBar.value -= delta
		Timerlabel.text = str(TimerBar.value)
		# Check if the timer raeches 0 seconds.
		# Will then call '_on_next_arrow_pressed' until out of lives and continues to end screen.
		if (TimerBar.value <= 0):
			Timerlabel.text = "Time's Up!"
			await get_tree().create_timer(1).timeout
			_on_next_arrow_pressed()


# This fucntion updates the label used for displaying the question with the question of the card of
# the passed index value, and resets the answer line edit to be empty.
func display_card(card_idx: int):
	QLabel.text = cards[card_idx]["Question"]
	if(cards[card_idx]["Free Response"] == true):
		answer_line_edit.set_visible(true)
		MultipleChoice.set_visible(false)
		TrueFalseChoice.set_visible(false)
		answer_line_edit.text = ""
	if(cards[card_idx]["Multiple Choice"] == true):
		answer_line_edit.set_visible(false)
		MultipleChoice.set_visible(true)
		TrueFalseChoice.set_visible(false)
		a1_button.text = cards[card_idx]["Multiple Answers"]["answer1"]
		a2_button.text = cards[card_idx]["Multiple Answers"]["answer2"]
		a3_button.text = cards[card_idx]["Multiple Answers"]["answer3"]
		a4_button.text = cards[card_idx]["Multiple Answers"]["answer4"]
	if(cards[card_idx]["T/F Choice"] == true):
		answer_line_edit.set_visible(false)
		MultipleChoice.set_visible(false)
		TrueFalseChoice.set_visible(true)


# This function is called when the user clicks on the next arrow button.
# This function just calls '_on answer_line_edit_text_submitted' with the text entered by the user
# in the answer box so it will have the same functionality as the user pressing enter.
func _on_next_arrow_pressed() -> void:
	_on_answer_line_edit_text_submitted(answer_line_edit.text)


func _on_prev_arrow_pressed() -> void:
	if (currentCard != 1):
		currentCard = currentCard - 1


# This function is called when the back button is pressed.
# It will leave study mode and take the user back to the main menu.
func _on_exit_button_pressed() -> void:
	SceneTransitioner.transition_in_from_top_bounce("res://Scenes/MainSceneControl.tscn")


func deck_complete(msg: String, wait_time: int = 1):
	# Set 'game_over' to true and 'count_down_timer' to false to stop the timer from counting down.
	game_over = true
	count_down_timer = false
	Timerlabel.text = msg
	
	# Set variables in 'Global' for the next screen to pull from.
	Global.num_cards = num_cards
	Global.cards_correct = cards_correct
	Global.cards_wrong = cards_wrong
	Global.lives_left = lives_idx + 1
	
	await get_tree().create_timer(wait_time).timeout
	SceneTransitioner.transition_in_from_right_cubic("res://Scenes/DeckEnd.tscn")


func _on_answer_line_edit_text_submitted(new_text: String) -> void:
	# If game has already ended, dont process or let the user attempt any other answers
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
		answer_correct(true)
	else:
		answer_correct(false)

func answer_correct(isCorrect: bool) -> void:
	if isCorrect:
		# TODO: Some visual and audio effect for correct answer
		AudioPlayer.play_sound_effect(correct_sfx, 0.25)
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
		AudioPlayer.play_sound_effect(wrong_sfx, 0.25)
		progress_labels[current_card_idx].modulate = Color.RED
		cards_wrong += 1
		
		# If lives are left, subtract one life.
		if lives_idx >= 0:
			# Change the red heart to a black heart
			lives[lives_idx].texture = black_heart_texture
			# Use a 'tween' to shrink the heart over set time.
			var tween = get_tree().create_tween()
			tween.tween_property(lives[lives_idx], "custom_minimum_size", Vector2(0, 0), 0.25)
			tween.tween_callback(lives[lives_idx].hide)
			lives_idx -= 1
		
		# If there are no more lives left, lose the game
		if lives_idx < 0:
			Global.lost = true
			deck_complete("Out of lives!", 2)
			# TODO: Lose game here with some visual and audio effects.
			return
		
		# If this is the final card, go to end screen. Else go to next card
		if current_card_idx == num_cards - 1:
			deck_complete("Deck Complete!", 2)
		else:
			current_card_idx += 1
			display_card(current_card_idx)

func _on_true_button_pressed() -> void:
	if (cards[current_card_idx]["Answer"] == "True"):
		answer_correct(true)
	else:
		answer_correct(false)


func _on_false_button_pressed() -> void:
	if (cards[current_card_idx]["Answer"] == "False"):
		answer_correct(true)
	else:
		answer_correct(false)


func _on_a1_button_pressed() -> void:
	if (cards[current_card_idx]["Answer"] == "1"):
		answer_correct(true)
	else:
		answer_correct(false)


func _on_a2_button_pressed() -> void:
	if (cards[current_card_idx]["Answer"] == "2"):
		answer_correct(true)
	else:
		answer_correct(false)


func _on_a3_button_pressed() -> void:
	if (cards[current_card_idx]["Answer"] == "3"):
		answer_correct(true)
	else:
		answer_correct(false)


func _on_a4_button_pressed() -> void:
	if (cards[current_card_idx]["Answer"] == "4"):
		answer_correct(true)
	else:
		answer_correct(false)
