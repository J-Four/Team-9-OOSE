extends Control

@onready var correct100img: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HFlowContainer/100Correct/Label/HBoxContainer/MarginContainer/Label")
@onready var correct100label: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HFlowContainer/100Correct/Label/HBoxContainer/Label2")
@onready var wrong100img: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HFlowContainer/100Wrong/Label/HBoxContainer/MarginContainer/Label")
@onready var wrong100label: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HFlowContainer/100Wrong/Label/HBoxContainer/Label2")
@onready var study20img: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HFlowContainer/20Sessions/Label/HBoxContainer/MarginContainer/Label")
@onready var study20label: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HFlowContainer/20Sessions/Label/HBoxContainer/Label2")
@onready var bp100img: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HFlowContainer/100BP/Label/HBoxContainer/MarginContainer/Label")
@onready var bp100label: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HFlowContainer/100BP/Label/HBoxContainer/Label2")
@onready var buddyUnlockedimg: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HFlowContainer/buddyUnlocked/Label/HBoxContainer/MarginContainer/Label")
@onready var buddyUnlockedlabel: Label = get_node("PanelContainer2/VBoxContainer/PanelContainer2/HFlowContainer/buddyUnlocked/Label/HBoxContainer/Label2")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkAchievement()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func checkAchievement() -> void:
	if (not Global.userAchievements["100_Correct"]["Achieved"]):
		correct100img.self_modulate = Global.grayedOut
		correct100label.set("theme_override_colors/font_color", Global.grayedOut)
		correct100label.set("theme_override_colors/font_outline_color", Global.grayedOut)
	if (not Global.userAchievements["100_wrong"]["Achieved"]):
		wrong100img.self_modulate = Global.grayedOut
		wrong100label.set("theme_override_colors/font_color", Global.grayedOut)
		wrong100label.set("theme_override_colors/font_outline_color", Global.grayedOut)
	if (not Global.userAchievements["20_study_sessions"]["Achieved"]):
		study20img.self_modulate = Global.grayedOut
		study20label.set("theme_override_colors/font_color", Global.grayedOut)
		study20label.set("theme_override_colors/font_outline_color", Global.grayedOut)
	if (not Global.userAchievements["100_BP"]["Achieved"]):
		bp100img.self_modulate = Global.grayedOut
		bp100label.set("theme_override_colors/font_color", Global.grayedOut)
		bp100label.set("theme_override_colors/font_outline_color", Global.grayedOut)
	if (not Global.userAchievements["first_buddy_unlocked"]["Achieved"]):
		buddyUnlockedimg.self_modulate = Global.grayedOut
		buddyUnlockedlabel.set("theme_override_colors/font_color", Global.grayedOut)
		buddyUnlockedlabel.set("theme_override_colors/font_outline_color", Global.grayedOut)

func _on_ok_pressed() -> void:
	SceneTransitioner.transition_in_from_right_cubic("res://Scenes/MainSceneControl.tscn")
