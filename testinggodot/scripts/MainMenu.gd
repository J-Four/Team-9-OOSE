extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/CreateDeck.tscn")


func _on_deck_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_deck_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_deck_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_deck_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_deck_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_deck_6_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playDeck.tscn")


func _on_edit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/EditDecks.tscn")


func _on_create_deck_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/CreateDeck.tscn")
