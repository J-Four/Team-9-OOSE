extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _Exit_deck_on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainSceneControl.tscn")
	pass # Replace with function body.


func _on_next_arrow_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/DeckEnd.tscn")
	pass # Replace with function body.
