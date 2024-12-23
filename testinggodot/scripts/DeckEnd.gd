extends Node

@onready var ok_button: Button = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OKButton")
@onready var stats_label: Label = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/StatsLabel/StatsLabel2")
@onready var title_label: Label = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel")
@onready var progress_bar: ProgressBar = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/ProgressBar2")
@onready var level_label: Label = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/LevelLabel")
@onready var next_level_label: Label = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/NextLevelLabel")
@onready var earned_xp_label: Label = get_node("PanelContainer/VBoxContainer/PanelContainer2/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/EarnedXPLabel")
@onready var confetti_particles_1: CPUParticles2D = get_node("CPUParticles2D")
@onready var confetti_particles_2: CPUParticles2D = get_node("CPUParticles2D2")
@onready var lvl_up_particles: CPUParticles2D = get_node("LvlUpParticles")
@onready var win_sound_1: AudioStream = preload("res://Assets/Audio/Quick Cheer B.wav")
@onready var win_sound_2: AudioStream = preload("res://Assets/Audio/Polite Clap.wav")
@onready var lose_sound_1: AudioStream = preload("res://Assets/Audio/Sarcastic Clap.wav")
@onready var lvl_up_sound: AudioStream = preload("res://Assets/Audio/boom2.wav")
@onready var lvl_up_sound_2: AudioStream = preload("res://Assets/Audio/Mobile Compound 004.wav")
@onready var screenColorWin: ColorRect = get_node("PanelContainer/VBoxContainer/PanelContainer2/ColorRectWin")
@onready var screenColorLose: ColorRect = get_node("PanelContainer/VBoxContainer/PanelContainer2/ColorRectLose")
var xp_per_correct: int = 10
var xp_per_heart: int = 25
var bp_per_heart: int = 1
var bp_per_session: int = 5
var brainPowerAdded: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.lost: #effects if player lost
		title_label.text = "You ran out of lives! D="
		confetti_particles_1.hide()
		confetti_particles_2.hide()
		AudioPlayer.play_sound_effect(lose_sound_1)
		screenColorLose.visible = true
		screenColorWin.visible = false
	else: #effects if player won
		AudioPlayer.play_sound_effect_2(win_sound_2)
		AudioPlayer.play_sound_effect(win_sound_1)
		screenColorLose.visible = false
		screenColorWin.visible = true
	
	# TODO: Maybe change way xp is earned from per card to percent correct.
	if Global.cards_correct == 0:
		xp_per_heart = 0
	var total_xp_earned: int = (Global.cards_correct * xp_per_correct) + (xp_per_heart * Global.lives_left)
	var lvl: int = Global.get_level_from_xp(Global.deck_data["XP"])
	var next_lvl_xp: int = Global.get_xp_from_level(lvl + 1)
	var new_xp_val: int = Global.deck_data["XP"] + total_xp_earned
	brainPowerAdded = (Global.lives_left * bp_per_heart) + bp_per_session #where BP earned is determined
	
	#updating relevant values
	Global.brainPower = Global.brainPower + brainPowerAdded 
	update_level_labels(lvl, total_xp_earned)
	stats_label.text = "Total cards: \t" + str(Global.num_cards) + "\nCorrect: \t\t" + str(Global.cards_correct) + "\t +" + str(Global.cards_correct * xp_per_correct) + "xp\nIncorrect: \t" + str(Global.cards_wrong) + "\nLives left: \t" + str(Global.lives_left) + "\t +" + str(Global.lives_left * xp_per_heart) + "xp\nTotal XP gained: " + str(total_xp_earned) + "xp\nTotal BP gained: " + str(brainPowerAdded)
	
	tween_progress_bar(Global.get_xp_from_level(lvl), Global.get_xp_from_level(lvl + 1), Global.deck_data["XP"], new_xp_val, lvl)
	
	update_achievements()
	Global.write_successful.connect(ok_button.show)
	Global.add_and_save_xp_to_deck(total_xp_earned)


func update_achievements() -> void: #update achievements with new data
	Global.userAchievements["100_Correct"]["needed_to_complete"] = Global.userAchievements["100_Correct"]["needed_to_complete"] - Global.cards_correct
	Global.userAchievements["100_wrong"]["needed_to_complete"] = Global.userAchievements["100_wrong"]["needed_to_complete"] - Global.cards_wrong
	Global.userAchievements["20_study_sessions"]["needed_to_complete"] = Global.userAchievements["20_study_sessions"]["needed_to_complete"] - 1
	Global.userAchievements["100_BP"]["needed_to_complete"] = Global.userAchievements["100_BP"]["needed_to_complete"] - brainPowerAdded
	Global.update_achievements()

func tween_progress_bar(min: int, max: int, current_xp: int, to_xp: int, lvl: int):
	progress_bar.min_value = min
	progress_bar.max_value = max
	progress_bar.value = current_xp
	
	var tween = get_tree().create_tween()
	# If new xp val is greater than next lvl xp val, tween to the max and call this func again for the remaining xp
	if to_xp >= max:
		tween.tween_property(progress_bar, "value", max, 2.0)
		tween.tween_callback(level_up.bind(lvl))
		tween.tween_callback(tween_progress_bar.bind(Global.get_xp_from_level(lvl + 1), Global.get_xp_from_level(lvl + 2), max, to_xp, lvl + 1))
	else:
		tween.tween_property(progress_bar, "value", to_xp, 2.0)


func level_up(lvl: int): #ran only when user has earned enough to level up
	lvl += 1
	update_level_labels(lvl)
	lvl_up_particles.restart()
	AudioPlayer.play_sound_effect_3(lvl_up_sound)
	# TODO: Do other effects and stuff here


func update_level_labels(lvl: int, xp_earned: int = -1):
	level_label.text = "Level " + str(lvl)
	if xp_earned != -1:
		earned_xp_label.text = "+" + str(xp_earned) + "xp"
	next_level_label.text = str(lvl + 1)


func _on_ok_button_pressed() -> void:
	Global.reset()
	SceneTransitioner.transition_in_from_right_cubic("res://Scenes/MainSceneControl.tscn")
