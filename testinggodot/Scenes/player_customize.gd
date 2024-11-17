extends Control


@onready var spriteChar: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer3/PanelContainer/Sprite")
@onready var MAdventureTheme: Resource = preload("res://Assets/Themes/SpriteMAdventure.tres")
@onready var FAdventureTheme: Resource = preload("res://Assets/Themes/SpriteFAdventure.tres")
@onready var MSkellyTheme: Resource = preload("res://Assets/Themes/SpriteMSkelly.tres")
@onready var FSkellyTheme: Resource = preload("res://Assets/Themes/SpriteFSkelly.tres")
@onready var ElfTheme: Resource = preload("res://Assets/Themes/SpriteElf.tres")
@onready var PrincessTheme: Resource = preload("res://Assets/Themes/SpritePrincess.tres")
@onready var costLabel: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/VBoxContainer/cost_label")
@onready var buyButton: Button = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/VBoxContainer/Button")
@onready var lockedOrUnlockedLabel: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/VBoxContainer/locked_unlocked")
@onready var BPCount: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer/HBoxContainer/MarginContainer2/BP_Count")

var clickedSprite
var spriteCost = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_sprite(Global.spriteChosen)

func update_label_lock(spriteCheck: String) -> void:
	if (Global.unlockedSprites[spriteCheck]):
		lockedOrUnlockedLabel.text = " Unlocked "
		costLabel.text = ""
		costLabel.visible = false
		buyButton.visible = false
	else: 
		lockedOrUnlockedLabel.text = " Locked "
		costLabel.text = " " + str(spriteCost) + "BP to unlock. "
		costLabel.visible = true
		buyButton.visible = true
	BPCount.text = "Current Brain Power:  " + str(Global.brainPower)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_sprite(spriteCheck: String) -> void:
	if(spriteCheck == "MAdventurer"):
		spriteChar.theme = MAdventureTheme
	if(spriteCheck == "FAdventurer"):
		spriteChar.theme = FAdventureTheme
	if(spriteCheck == "MSkelly"):
		spriteChar.theme = MSkellyTheme
	if(spriteCheck == "FSkelly"):
		spriteChar.theme = FSkellyTheme
	if(spriteCheck == "Elf"):
		spriteChar.theme = ElfTheme
	if(spriteCheck == "Princess"):
		spriteChar.theme = PrincessTheme
	update_label_lock(spriteCheck)
		

func _on_cancel_pressed() -> void:
	# TODO: go to main menu w/o saving
	SceneTransitioner.transition_in_from_right_cubic("res://Scenes/MainSceneControl.tscn")


func _on_ok_pressed(display_popup: bool = true) -> void:
	# TODO: go to main menu and save
	if ( not (clickedSprite == null)):
		if Global.unlockedSprites[clickedSprite]: #if sprite unlocked, then accept selection
			Global.spriteChosen = clickedSprite
			SceneTransitioner.transition_in_from_right_cubic("res://Scenes/MainSceneControl.tscn")
		else:
			print("buddy not unlocked")
			#TODO add pop-up
	else: 
		_on_cancel_pressed()
	




func _on_male_adventure_pressed() -> void:
	clickedSprite = "MAdventurer"
	update_sprite(clickedSprite)
	


func _on_female_adventure_pressed() -> void:
	clickedSprite = "FAdventurer"
	update_sprite(clickedSprite)


func _on_male_skeleton_pressed() -> void:
	clickedSprite = "MSkelly"
	update_sprite(clickedSprite)


func _on_female_skeleton_pressed() -> void:
	clickedSprite = "FSkelly"
	update_sprite(clickedSprite)


func _on_elf_pressed() -> void:
	clickedSprite = "Elf"
	update_sprite(clickedSprite)


func _on_princess_pressed() -> void:
	clickedSprite = "Princess"
	update_sprite(clickedSprite)


func _on_buy_button_pressed() -> void:
	# verify enough BP, subtract BP, unlock sprite
	if (not Global.unlockedSprites[clickedSprite]):
		if (Global.brainPower >= spriteCost):
			Global.brainPower = Global.brainPower - spriteCost
			Global.unlockedSprites[clickedSprite] = true
			update_label_lock(clickedSprite)
			Global.userAchievements["first_buddy_unlocked"]["Achieved"] = true
		else:
			print("Not enough brain power.")
			#TODO: add popup?
	#for all sprites, need to gray out locked ones
