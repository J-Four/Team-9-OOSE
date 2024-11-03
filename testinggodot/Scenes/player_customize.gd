extends Control

@onready var MAdventureOpts: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/MAdventureOpt")
@onready var FAdventureOpts: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/FAdventureOpt")
@onready var MSkellyOpts: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/MSkellyOpt")
@onready var FSkellyOpts: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/FSkellyOpt")
@onready var ElfOpts: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/ElfOpt")
@onready var PrincessOpts: VBoxContainer = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer2/PrincessOpt")
@onready var spriteChar: Label = get_node("PanelContainer/VBoxContainer/PanelContainer2/HBoxContainer2/PanelContainer3/PanelContainer/Sprite")
@onready var MAdventureTheme: Resource = preload("res://Assets/Themes/SpriteMAdventure.tres")
@onready var FAdventureTheme: Resource = preload("res://Assets/Themes/SpriteFAdventure.tres")
@onready var MSkellyTheme: Resource = preload("res://Assets/Themes/SpriteMSkelly.tres")
@onready var FSkellyTheme: Resource = preload("res://Assets/Themes/SpriteFSkelly.tres")
@onready var ElfTheme: Resource = preload("res://Assets/Themes/SpriteElf.tres")
@onready var PrincessTheme: Resource = preload("res://Assets/Themes/SpritePrincess.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_sprite()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_sprite() -> void:
	if(Global.spriteChosen == "MAdventure"):
		spriteChar.theme = MAdventureTheme
	if(Global.spriteChosen == "FAdventure"):
		spriteChar.theme = FAdventureTheme
	if(Global.spriteChosen == "MSkelly"):
		spriteChar.theme = MSkellyTheme
	if(Global.spriteChosen == "FSkelly"):
		spriteChar.theme = FSkellyTheme
	if(Global.spriteChosen == "Elf"):
		spriteChar.theme = ElfTheme
	if(Global.spriteChosen == "Princess"):
		spriteChar.theme = PrincessTheme

func _on_cancel_pressed() -> void:
	# TODO: go to main menu w/o saving
	get_tree().change_scene_to_file("res://Scenes/MainSceneControl.tscn")


func _on_ok_pressed() -> void:
	# TODO: go to main menu and save
	get_tree().change_scene_to_file("res://Scenes/MainSceneControl.tscn")




func _on_male_adventure_pressed() -> void:
	MAdventureOpts.set_visible(true)
	FAdventureOpts.set_visible(false)
	MSkellyOpts.set_visible(false)
	FSkellyOpts.set_visible(false)
	ElfOpts.set_visible(false)
	PrincessOpts.set_visible(false)
	Global.spriteChosen = "MAdventure"
	update_sprite()
	


func _on_female_adventure_pressed() -> void:
	MAdventureOpts.set_visible(false)
	FAdventureOpts.set_visible(true)
	MSkellyOpts.set_visible(false)
	FSkellyOpts.set_visible(false)
	ElfOpts.set_visible(false)
	PrincessOpts.set_visible(false)
	Global.spriteChosen = "FAdventure"
	update_sprite()


func _on_male_skeleton_pressed() -> void:
	MAdventureOpts.set_visible(false)
	FAdventureOpts.set_visible(false)
	MSkellyOpts.set_visible(true)
	FSkellyOpts.set_visible(false)
	ElfOpts.set_visible(false)
	PrincessOpts.set_visible(false)
	Global.spriteChosen = "MSkelly"
	update_sprite()


func _on_female_skeleton_pressed() -> void:
	MAdventureOpts.set_visible(false)
	FAdventureOpts.set_visible(false)
	MSkellyOpts.set_visible(false)
	FSkellyOpts.set_visible(true)
	ElfOpts.set_visible(false)
	PrincessOpts.set_visible(false)
	Global.spriteChosen = "FSkelly"
	update_sprite()


func _on_elf_pressed() -> void:
	MAdventureOpts.set_visible(false)
	FAdventureOpts.set_visible(false)
	MSkellyOpts.set_visible(false)
	FSkellyOpts.set_visible(false)
	ElfOpts.set_visible(true)
	PrincessOpts.set_visible(false)
	Global.spriteChosen = "Elf"
	update_sprite()


func _on_princess_pressed() -> void:
	MAdventureOpts.set_visible(false)
	FAdventureOpts.set_visible(false)
	MSkellyOpts.set_visible(false)
	FSkellyOpts.set_visible(false)
	ElfOpts.set_visible(false)
	PrincessOpts.set_visible(true)
	Global.spriteChosen = "Princess"
	update_sprite()
