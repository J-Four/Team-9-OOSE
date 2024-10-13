extends CanvasLayer

@onready var transition_rect: TextureRect = get_node("TextureRect")
@onready var slide_bounce_sfx: Resource = preload("res://Assets/Audio/slide_bounce_louder.wav")
var transitioning: bool = false


# This function will move the 'transition_rect' in to the screen from the right in a given time.
func transition_in_from_right_cubic(next_scene: String, transition_time: float = 0.35):
	if transitioning:
		return
	transitioning = true
	transition_rect.position.x = get_viewport().size.x
	transition_rect.position.y = 0
	transition_rect.show()
	
	var tween = get_tree().create_tween()
	tween.tween_property(transition_rect, "position", Vector2(0, 0), transition_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_scene)).set_delay(transition_time)
	tween.tween_callback(transition_out_to_left.bind(transition_time, 0))#.set_delay(transition_time)


# This function will move the 'transition_rect' out of the screen to the left in a given time.
func transition_out_to_left(transition_time: float = 0.25, wait_time: float = 0):
	transition_rect.position.y = 0
	transition_rect.position.x = 0
	transition_rect.show()
	
	if wait_time > 0:
		await get_tree().create_timer(wait_time).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(transition_rect, "position", Vector2(-get_viewport().size.x, 0), transition_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(transition_rect.hide)#.set_delay(transition_time)
	tween.tween_callback(set_transitioning.bind(false))


# This function will move the 'transition_rect' in to the screen from the top with a bounce effect
# in a given time.
func transition_in_from_top_bounce(next_scene: String, transition_time: float = 0.7):
	if transitioning:
		return
	transitioning = true
	transition_rect.position.y = -get_viewport().size.y
	transition_rect.position.x = 0
	transition_rect.show()
	
	AudioPlayer.play_sound_effect(slide_bounce_sfx)
	
	var tween = get_tree().create_tween()
	tween.tween_property(transition_rect, "position", Vector2(0, 0), transition_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_scene)).set_delay(transition_time)
	tween.tween_callback(transition_out_to_top.bind(1, 0))#.set_delay(transition_time)


# This function will move the 'transition_rect' out of the screen to the top in a given time.
func transition_out_to_top(transition_time: float = 0.25, wait_time: float = 0):
	transition_rect.position.y = 0
	transition_rect.show()
	
	if wait_time > 0:
		await get_tree().create_timer(wait_time).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(transition_rect, "position", Vector2(0, -get_viewport().size.y), transition_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(transition_rect.hide)#.set_delay(transition_time)
	tween.tween_callback(set_transitioning.bind(false))


func set_transitioning(val: bool):
	transitioning = val
