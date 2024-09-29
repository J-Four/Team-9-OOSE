extends Node

@onready var Deckname 
@onready var PrevArrow : Button = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PrevArrow")
@onready var NextArrow : Button = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/NextArrow")
@onready var QLabel : Label = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/QLabel")
@onready var ATextEdit : TextEdit = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ATextEdit")
@onready var TimerBar : ProgressBar = get_node("PanelContainer/VBoxContainer/PanelContainer3/MarginContainer/ProgressBar")
@onready var Timerlabel : Label = get_node("PanelContainer/VBoxContainer/PanelContainer3/TimerLabel")


var currentCard : int = 1
var numCards: int = 1
var currentDeck : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Deckname.ChosenDeck.connect(_open_deck)
	TimerBar.value = 100
	_open_deck("SomeDeck")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	TimerBar.value = TimerBar.value - 0.01
	Timerlabel.text = str(roundf(TimerBar.value))
	if (TimerBar.value == 0):
		Timerlabel.text = "Time's Up!"
		await get_tree().create_timer(1).timeout
		_on_next_arrow_pressed()


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
		else:
			MessageDisplayer.error_popup("JSON parse error: " + json.get_error_message() + " in " + data_str, self)
	else:
		QLabel.text = "deck not found"
		print("deck not fdound")

func _load_deck(Dname : String, data : Dictionary):
	PrevArrow.visible = false
	currentDeck = data
	numCards = len(data["cards"]) #getting number of cards
	QLabel.text = str(data["Cards"][currentCard]["Question"]) #filling in question text
	
	pass

func _change_card_display(idx : int):
	if (idx == 0): # if first card turn off left arrow
		PrevArrow.visible = false
	else:
		PrevArrow.visible = true
	if (idx == numCards): # if last card turn off right arrow
		NextArrow.visible = false
	else:
		NextArrow.visibile = true
	QLabel.text = str(currentDeck["Cards"][currentCard]["Question"]) #filling in question text

	


func _on_next_arrow_pressed() -> void:
	if (currentCard == numCards):
		get_tree().change_scene_to_file("res://Scenes/DeckEnd.tscn")
	else: 
		currentCard = currentCard + 1
		_change_card_display(currentCard)
	

func _on_prev_arrow_pressed() -> void:
	if (currentCard != 1):
		currentCard = currentCard - 1
		_change_card_display(currentCard)
	


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainSceneControl.tscn")
